//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class BanksServiceAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(BanksService.self, name: nil) { resolver in
            DefaultBanksService(resolver: resolver)
        }
        .scope(.cached)
    }
}
