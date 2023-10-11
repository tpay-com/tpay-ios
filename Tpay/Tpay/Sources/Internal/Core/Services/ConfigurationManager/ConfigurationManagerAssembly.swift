//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class ConfigurationManagerAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(ConfigurationManager.self, name: nil) { _ in
            DefaultConfigurationManager()
        }
        .implements(ConfigurationProvider.self)
        .implements(ConfigurationSetter.self)
        .scope(.cached)
    }
}
