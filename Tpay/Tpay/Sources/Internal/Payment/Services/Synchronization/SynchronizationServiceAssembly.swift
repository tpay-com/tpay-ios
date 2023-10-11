//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class SynchronizationServiceAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(SynchronizationService.self, name: nil) { resolver in
            DefaultSynchronizationService(resolver: resolver)
        }
        .scope(.cached)
    }
}
