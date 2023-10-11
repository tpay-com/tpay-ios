//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension PaymentData {
    
    public enum DigitalWallet {
        
        // MARK: - Cases
        
        case applePay(ApplePayModel)
    }
}

extension PaymentData.DigitalWallet {
    
    public struct ApplePayModel {
        
        // MARK: - Properties
        
        let token: String
    }
}
