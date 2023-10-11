//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultAuthorizationHeadersProvider: AuthorizationHeadersProvider {
    
    // MARK: - Properties
    
    private let credentialsProvider: CredentialsProvider
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(with: resolver.resolve())
    }
    
    init(with credentialsProvider: CredentialsProvider) {
        self.credentialsProvider = credentialsProvider
    }
    
    // MARK: - API
    
    func headers(for resource: NetworkResource) -> [HttpHeader] {
        switch resource.authorization {
        case .basic:
            if let credentials = credentialsProvider.credentials {
                return [BasicAuthorization(for: credentials)]
            }
            return []
        case .bearer:
            if let claims = credentialsProvider.claims {
                return [BearerAuthorization(from: .init(accessToken: claims.accessToken))]
            }
            return []
        }
    }
}
