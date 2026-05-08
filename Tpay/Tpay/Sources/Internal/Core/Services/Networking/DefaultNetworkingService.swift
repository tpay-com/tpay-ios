//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultNetworkingService: NetworkingService {

    // MARK: - Properties

    private let requestFactory: RequestFactory
    private let session: Session
    private let validators: NetworkingValidators

    private let queue = DispatchQueue(label: "com.tpay.networking", qos: .userInitiated)

    // MARK: - Initializers

    init(requestFactory: RequestFactory,
         session: Session,
         errorValidator: ErrorValidator,
         responseValidator: ResponseValidator,
         bodyDecoder: BodyDecoder) {
        self.requestFactory = requestFactory
        self.session = session
        self.validators = NetworkingValidators(
            errorValidator: errorValidator,
            responseValidator: responseValidator,
            bodyDecoder: bodyDecoder
        )
    }

    // MARK: - API

    func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType {
        let requestResult = NetworkRequestResult<ResponseType>()
        queue.async { [self] in self.execute(request: request, for: requestResult) }
        return requestResult
    }

    // MARK: - Private

    private func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType, for result: NetworkRequestResult<ResponseType>) where ResponseType == RequestType.ResponseType {
        // TPS-55: `requestFactory.request(for:)` now throws (`NetworkingError.notConfigured`,
        // `NetworkingError.invalidURL`) instead of calling `preconditionFailure`. Catch and
        // route the error through the result handler so the caller receives a Promise rejection
        // / completion failure instead of an EXC_BREAKPOINT crash on `com.tpay.networking`.
        let urlRequest: URLRequest
        do {
            urlRequest = try requestFactory.request(for: request)
        } catch {
            result.handle(error: error)
            return
        }

        Logger.request(urlRequest)

        // URLSession completion captures only [self, result] — two class references.
        // No protocol-typed locals are captured here, so the closure's destruction does
        // not trigger boxed-existential value-witness destroys.
        result.networkTask = session.invoke(request: urlRequest) { [self, result] data, response, error in
            self.handle(result: result, data: data, response: response, error: error)
        }
    }

    private func handle<ResponseType: Decodable>(result: NetworkRequestResult<ResponseType>,
                                                 data: Data?,
                                                 response: URLResponse?,
                                                 error: Error?) {
        Logger.response(data, response, error)

        // Inner dispatch captures [self, result] explicitly. data/response/error are
        // implicitly captured but are URLSession-owned values — not validator existentials.
        queue.async { [self, result] in
            self.complete(result: result, data: data, response: response, error: error)
        }
    }

    private func complete<ResponseType: Decodable>(result: NetworkRequestResult<ResponseType>,
                                                   data: Data?,
                                                   response: URLResponse?,
                                                   error: Error?) {
        do {
            try validators.errorValidator.validate(error: error)
            try validators.responseValidator.validate(response: response, with: data)

            // TPS-55: was `preconditionFailure("Response validator should handle this case!")`.
            // Reaching this branch means the response validator passed (status 2xx) but the
            // body is empty. Surface as a decodable invalid-response error rather than crashing.
            guard let data = data else {
                result.handle(error: NetworkingError.invalidResponse(.undecodableResponseBody))
                return
            }

            result.handle(success: try validators.bodyDecoder.decode(body: data))
        } catch {
            result.handle(error: error)
        }
    }
}
