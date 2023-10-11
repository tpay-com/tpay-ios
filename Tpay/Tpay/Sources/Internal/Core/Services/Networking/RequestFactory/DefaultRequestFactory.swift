//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultRequestFactory: RequestFactory {
    
    // MARK: - Properties
    
    private let networkingConfigurationProvider: NetworkingConfigurationProvider
    private let headersProvider: HttpHeadersProvider
    private let queryEncoder: QueryEncoder
    private let bodyEncoder: BodyEncoder
    
    // MARK: - Initializers
    
    init(networkingConfigurationProvider: NetworkingConfigurationProvider,
         headersProvider: HttpHeadersProvider,
         queryEncoder: QueryEncoder,
         bodyEncoder: BodyEncoder) {
        self.networkingConfigurationProvider = networkingConfigurationProvider
        self.headersProvider = headersProvider
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
    
    // MARK: - API
    
    func request<RequestType: NetworkRequest>(for object: RequestType) -> URLRequest {
        let method = object.resource.method
    
        guard let serviceConfiguration = networkingConfigurationProvider.configuration else {
            preconditionFailure("Unable to get networking configuration")
        }
        
        var components = serviceConfiguration.components
        components.path = object.resource.url.absoluteString
        
        if let params = object.resource.queryParameters {
            components.queryItems = queryEncoder.queryItems(from: EncodableWrapper(item: params))
        }
        
        guard let url = components.url else {
            preconditionFailure("Unable to create URL from components: \(components)")
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
