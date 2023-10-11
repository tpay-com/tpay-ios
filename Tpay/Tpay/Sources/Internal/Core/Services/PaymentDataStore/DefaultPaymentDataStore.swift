//
//  Copyright © 2023 Tpay. All rights reserved.
//

class DefaultPaymentDataStore: PaymentDataStore {
    
    // MARK: - Properties
    
    var paymentMethods: [Domain.PaymentMethod] = []
    
    // MARK: - API
    
    func set(paymentMethods: [Domain.PaymentMethod]) {
        self.paymentMethods = paymentMethods
    }
}
