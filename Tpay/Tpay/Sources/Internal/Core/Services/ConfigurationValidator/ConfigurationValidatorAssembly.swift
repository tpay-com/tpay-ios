//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class ConfigurationValidatorAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(ConfigurationValidator.self, name: nil) { resolver in
            DefaultConfigurationValidator(resolver: resolver)
        }
        .scope(.cached)
    }
}
