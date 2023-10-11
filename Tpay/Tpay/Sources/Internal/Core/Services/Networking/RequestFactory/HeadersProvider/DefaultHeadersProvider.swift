//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultHeadersProvider: HttpHeadersProvider {
    
    // MARK: - Properties
    
    private let headersProviders: [HttpHeadersProvider]
    
    // MARK: - Initializers
    
    init(authorizationHeadersProvider: AuthorizationHeadersProvider) {
        headersProviders = [authorizationHeadersProvider]
    }
    
    // MARK: - API
    
    func headers(for resource: NetworkResource) -> [HttpHeader] {
        headersProviders.flatMap { provider in provider.headers(for: resource) }
    }
}
