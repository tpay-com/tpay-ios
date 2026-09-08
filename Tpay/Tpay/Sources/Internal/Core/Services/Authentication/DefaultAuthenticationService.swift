//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultAuthenticationService: AuthenticationService {

    // MARK: - Properties

    private let networkingService: NetworkingService
    private let credentialsStore: CredentialsStore
    private let credentialsProvider: CredentialsProvider
    private let dateProvider: DateProvider

    /// Never `sync` — a completion can re-enter `authenticate`, as the `401` path in
    /// `AuthenticatingNetworkingService` does.
    private let queue = DispatchQueue(label: "com.tpay.authentication", qos: .userInitiated)

    // MARK: - Initializers

    convenience init(resolver: ServiceResolver) {
        self.init(using: resolver.resolve(),
                  credentialsStore: resolver.resolve(),
                  credentialsProvider: resolver.resolve())
    }

    init(using networkingService: NetworkingService,
         credentialsStore: CredentialsStore,
         credentialsProvider: CredentialsProvider,
         dateProvider: DateProvider = DefaultDateProvider()) {
        self.networkingService = networkingService
        self.credentialsStore = credentialsStore
        self.credentialsProvider = credentialsProvider
        self.dateProvider = dateProvider
    }

    // MARK: - API

    func authenticate(then: @escaping Completion) {
        queue.async { [self] in
            // No credentials yet (cold start, TPS-55): fetch a token anyway, don't cache it.
            let credentials = credentialsProvider.credentials

            if let credentials,
               let claims = credentialsProvider.claims,
               claims.isValid(at: dateProvider.now, for: credentials) {
                then(.success(()))
                return
            }
            requestToken(for: credentials, then: then)
        }
    }

    // MARK: - Private

    private func requestToken(for credentials: AuthorizationCredentials?, then: @escaping Completion) {
        networkingService.execute(request: AuthorizationController.Authorize())
            .onSuccess { [self] response in
                credentialsStore.store(claims: makeAuthorizationClaims(from: response, requestedFor: credentials))
                then(.success(()))
            }
            .onError { error in then(.failure(error)) }
    }

    /// The `Basic` header is built lazily, so the request may have gone out with credentials
    /// newer than the ones it was started for — such a token must not be cached.
    private func makeAuthorizationClaims(from authorizeResponse: AuthorizationController.Authorize.Response,
                                         requestedFor credentials: AuthorizationCredentials?) -> AuthorizationClaims {
        guard let expiresIn = authorizeResponse.expiresIn,
              let credentials, credentials == credentialsProvider.credentials else {
            return AuthorizationClaims(accessToken: authorizeResponse.accessToken)
        }
        return AuthorizationClaims(accessToken: authorizeResponse.accessToken,
                                   expiresAt: dateProvider.now.addingTimeInterval(expiresIn),
                                   issuedFor: credentials)
    }
}
