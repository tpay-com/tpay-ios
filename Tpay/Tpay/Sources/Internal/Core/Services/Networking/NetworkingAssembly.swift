//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class NetworkingAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(CredentialsManager.self, name: nil) { _ in
            DefaultCredentialsManager()
        }
        .implements(CredentialsProvider.self)
        .implements(CredentialsStore.self)
        .scope(.cached)
        
        container.register(AuthorizationHeadersProvider.self, name: nil) { resolver in
            DefaultAuthorizationHeadersProvider(resolver: resolver)
        }
        .scope(.cached)
        
        container.register(NetworkingService.self, name: nil) { resolver in
            NetworkingServiceFactory(using: resolver).make()
        }
        .scope(.cached)
        
        container.register(NetworkingConfigurationManager.self, name: nil) { _ in
            DefaultNetworkingConfigurationManager()
        }
        .implements(NetworkingConfigurationProvider.self)
        .implements(NetworkingConfigurationStore.self)
        .scope(.cached)
    }
}
