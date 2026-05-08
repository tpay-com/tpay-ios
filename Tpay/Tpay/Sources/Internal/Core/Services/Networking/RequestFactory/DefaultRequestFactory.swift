//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultRequestFactory: RequestFactory {

    // MARK: - Properties

    private let networkingConfigurationProvider: NetworkingConfigurationProvider
    private let headersProvider: HttpHeadersProvider
    private let queryEncoder: QueryEncoder
    private let bodyEncoder: BodyEncoder

    /// How long to block waiting for `configure(merchant:)` to publish a configuration before
    /// failing the request. 5 seconds covers realistic cold-start ordering windows; if the
    /// integrator never calls `configure`, the request fails fast with `NetworkingError.notConfigured`
    /// instead of hanging the queue forever. Made injectable for tests.
    private let configurationWaitTimeout: TimeInterval

    // MARK: - Initializers

    init(networkingConfigurationProvider: NetworkingConfigurationProvider,
         headersProvider: HttpHeadersProvider,
         queryEncoder: QueryEncoder,
         bodyEncoder: BodyEncoder,
         configurationWaitTimeout: TimeInterval = 5.0) {
        self.networkingConfigurationProvider = networkingConfigurationProvider
        self.headersProvider = headersProvider
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
        self.configurationWaitTimeout = configurationWaitTimeout
    }

    // MARK: - API

    func request<RequestType: NetworkRequest>(for object: RequestType) throws -> URLRequest {
        let method = object.resource.method

        // TPS-55: was `preconditionFailure("Unable to get networking configuration")` —
        // crashed (EXC_BREAKPOINT) when the SDK had not yet been configured. We now wait
        // briefly for `configure(merchant:)` to publish a configuration, then either build
        // the request normally or fail with `NetworkingError.notConfigured`.
        guard let serviceConfiguration = networkingConfigurationProvider.waitForConfiguration(timeout: configurationWaitTimeout) else {
            throw NetworkingError.notConfigured
        }

        var components = serviceConfiguration.components
        components.path = object.resource.url.absoluteString

        if let params = object.resource.queryParameters {
            components.queryItems = queryEncoder.queryItems(from: EncodableWrapper(item: params))
        }

        // TPS-55: was `preconditionFailure("Unable to create URL from components: ...")`
        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        for header in headersProvider.headers(for: object.resource) {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        urlRequest.httpBody = bodyEncoder.body(from: object, for: object.resource)

        return urlRequest
    }
}

private struct EncodableWrapper: Encodable {

    // MARK: - Properties

    let item: Encodable

    // MARK: - API

    func encode(to encoder: Encoder) throws {
        try item.encode(to: encoder)
    }
}
