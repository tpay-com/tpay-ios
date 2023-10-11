//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DigitalWalletServiceAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(DigitalWalletService.self, name: nil) { resolver in
            DefaultDigitalWalletService(resolver: resolver)
        }
        .scope(.cached)
    }
}
