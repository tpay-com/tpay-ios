//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation

/// Owns the token for the requests it decorates: refreshes it before a `Bearer` request and
/// repairs a `401` with a single replay.
final class AuthenticatingNetworkingService: NetworkingService {

    // MARK: - Properties

    private let networkingService: NetworkingService
    private let credentialsStore: CredentialsStore
    private let credentialsProvider: CredentialsProvider

    private let authenticationServiceFactory: () -> AuthenticationService

    // MARK: - Initializers

    init(
        decorating networkingService: NetworkingService,
        credentialsStore: CredentialsStore,
        credentialsProvider: CredentialsProvider,
        authenticationServiceFactory: @escaping () -> AuthenticationService
    ) {
        self.networkingService = networkingService
        self.credentialsStore = credentialsStore
        self.credentialsProvider = credentialsProvider
        self.authenticationServiceFactory = authenticationServiceFactory
    }

    // MARK: - API

    func execute<RequestType: NetworkRequest, ResponseType>(
        request: RequestType
    ) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType {
        // A result of our own — a retry needs a fresh `execute`, because `NetworkRequestResult`
        // clears its handlers after the first outcome.
        let result = NetworkRequestResult<ResponseType>()

        // Without credentials the token is never cacheable, so authenticating here would double
        // every request — that case is left to the `401` path.
        guard case .bearer = request.resource.authorization, let credentials = credentialsProvider.credentials else {
            execute(request: request, for: result, isRetry: false)
            return result
        }

        authenticationServiceFactory().authenticate { [self] outcome in
            // A token issued for other credentials would put the payment on another merchant's account.
            if case .failure(let error) = outcome, credentialsProvider.claims?.issuedFor != credentials {
                result.handle(error: error)
                return
            }
            execute(request: request, for: result, isRetry: false)
        }

        return result
    }

    // MARK: - Private

    private func execute<RequestType: NetworkRequest, ResponseType>(
        request: RequestType,
        for result: NetworkRequestResult<ResponseType>,
        isRetry: Bool
    ) where ResponseType == RequestType.ResponseType {
        let ongoingResult = networkingService.execute(request: request)

        let cancellation = CancellationProxy { [weak ongoingResult] in ongoingResult?.cancelTask() }
        result.networkTask = cancellation

        ongoingResult.onResult { [self, result, cancellation] outcome in
            _ = cancellation // `networkTask` is weak — this capture owns the proxy while the request runs
            handle(outcome, of: request, for: result, isRetry: isRetry)
        }
    }

    private func handle<RequestType: NetworkRequest, ResponseType>(
        _ outcome: Result<ResponseType, Error>,
        of request: RequestType,
        for result: NetworkRequestResult<ResponseType>,
        isRetry: Bool
    ) where ResponseType == RequestType.ResponseType {
        switch outcome {
        case .success(let response):
            result.handle(success: response)
        case .failure(let error):
            guard !isRetry, isUnauthorized(error), case .bearer = request.resource.authorization else {
                result.handle(error: error)
                return
            }
            refreshToken(then: { [self] refreshResult in
                switch refreshResult {
                case .success:
                    execute(request: request, for: result, isRetry: true)
                case .failure(let refreshError):
                    result.handle(error: refreshError)
                }
            })
        }
    }

    /// `removeClaims()` first — otherwise `authenticate` serves the rejected token back from
    /// the cache and the retry repeats the same `401`.
    private func refreshToken(then: @escaping Completion) {
        credentialsStore.removeClaims()
        authenticationServiceFactory().authenticate(then: then)
    }

    private func isUnauthorized(_ error: Error) -> Bool {
        guard case NetworkingError.serverError(let serverError) = error else { return false }
        return serverError.httpStatusCode == .unauthorized
    }
}

// MARK: - Cancellation

private final class CancellationProxy: NetworkTask {

    // MARK: - Properties

    private let cancellation: () -> Void

    // MARK: - Initializers

    init(cancellation: @escaping () -> Void) {
        self.cancellation = cancellation
    }

    // MARK: - API

    func cancel() {
        cancellation()
    }
}
