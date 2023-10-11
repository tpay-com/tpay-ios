//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain.Transaction {
    
    final class Builder {
        
        // MARK: - Properties
        
        private let paymentInfo: Domain.PaymentInfo
        private var payer: Domain.Payer?
        
        // MARK: - Initializers
        
        init(paymentInfo: Domain.PaymentInfo) {
            self.paymentInfo = paymentInfo
        }
        
        // MARK: - API
        
        func set(payer: Domain.Payer) {
            self.payer = payer
        }
        
        func build() -> Domain.Transaction? {
            guard let payer = payer else {
                return nil
            }
            return Domain.Transaction(paymentInfo: paymentInfo, payer: payer)
        }
    }
}
