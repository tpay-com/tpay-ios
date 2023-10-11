//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class PaymentDataStoreAssembly: Assembly {
     
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(PaymentDataStore.self, name: nil) { _ in
            DefaultPaymentDataStore()
        }
        .scope(.cached)
    }
}
