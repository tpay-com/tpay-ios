//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class ModuleContainer {
    
    // MARK: - Properties
    
    static let instance = ModuleContainer()
    
    var currentLanguage: Language?

    private var assembler: Assembler?
    private lazy var serviceContainer: ServiceContainer = DependenciesContainer()
    
    // MARK: - Initializers
    
    private init() {
        setup()
    }
    
    // MARK: - Private
    
    private func setup() {
        assembler = Assembler(with: serviceContainer, assemblies: [
            ConfigurationManagerAssembly(),
            ConfigurationValidatorAssembly(),
            BanksServiceAssembly(),
            PaymentMethodsAssembly(),
            PaymentDataStoreAssembly(),
            CallbacksDirectorAssembly(),
            NetworkingAssembly(),
            DigitalWalletServiceAssembly(),
            SynchronizationServiceAssembly()
        ])
    }
}

extension ModuleContainer: ResolverProvider {
    
    var resolver: ServiceResolver { serviceContainer }
}
