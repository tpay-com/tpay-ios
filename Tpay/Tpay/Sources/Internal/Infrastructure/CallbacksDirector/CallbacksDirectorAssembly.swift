//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CallbacksDirectorAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(CallbacksDirector.self, name: nil) { _ in
            DefaultCallbacksDirector()
        }
        .scope(.cached)
    }
}
