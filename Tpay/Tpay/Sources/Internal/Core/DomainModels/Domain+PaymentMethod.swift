//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain {
    
    enum PaymentMethod: Equatable {
        
        // MARK: - Cases
        
        case blik
        case pbl(Bank)
        case card
        case digitalWallet(DigitalWallet)
        
        case unknown
    }
}

extension Domain.PaymentMethod {
    
    static func ==(lhs: Domain.PaymentMethod, rhs: Domain.PaymentMethod) -> Bool {
        switch (lhs, rhs) {
        case (.blik, .blik), (.card, .card), (.unknown, .unknown): return true
        case (.pbl, .pbl(Domain.PaymentMethod.Bank.any)), (.pbl(Domain.PaymentMethod.Bank.any), .pbl): return true
        case let (.pbl(lhsValue), .pbl(rhsValue)): return lhsValue == rhsValue
        case (.digitalWallet, .digitalWallet(Domain.PaymentMethod.DigitalWallet.any)),
            (.digitalWallet(Domain.PaymentMethod.DigitalWallet.any), .digitalWallet): return true
        case let (.digitalWallet(lhsValue), .digitalWallet(rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}
