//
//  Copyright © 2023 Tpay. All rights reserved.
//

class DefaultPaymentDataStore: PaymentDataStore {
    
    // MARK: - Properties
    
    var paymentMethods: [Domain.PaymentMethod] = []
    var paymentChannels: [Domain.PaymentChannel] = []
    
    // MARK: - API
    
    func set(paymentMethods: [Domain.PaymentMethod]) {
        self.paymentMethods = paymentMethods
    }
    
    func set(paymentChannels: [Domain.PaymentChannel]) {
        self.paymentChannels = paymentChannels
    }
}
