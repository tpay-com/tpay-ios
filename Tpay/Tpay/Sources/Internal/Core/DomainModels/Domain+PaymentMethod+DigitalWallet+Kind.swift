//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain.PaymentMethod.DigitalWallet {
    
    enum Kind: Equatable {
        
        // MARK: - Cases

        case applePay
        case googlePay
        case payPal
        
        case unknown
    }
}
