//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol RequestFactory {

    // MARK: - API

    /// Builds a `URLRequest` for the given network request.
    ///
    /// TPS-55: now `throws` so callers receive a typed `NetworkingError` (e.g. `.notConfigured`,
    /// `.invalidURL`) instead of crashing via `preconditionFailure` when the SDK has not yet
    /// been configured or URL components are invalid.
    func request<RequestType: NetworkRequest>(for object: RequestType) throws -> URLRequest
}
