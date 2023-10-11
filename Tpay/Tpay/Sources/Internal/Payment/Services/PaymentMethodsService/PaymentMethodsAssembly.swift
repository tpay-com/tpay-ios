//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class PaymentMethodsAssembly: Assembly {
    
    // MARK: - API
    
    func assemble(into container: ServiceContainer) {
        container.register(PaymentMethodsService.self, name: nil) { resolver in
            DefaultPaymentMethodsService(resolver: resolver)
        }
        .scope(.cached)
    }
}
