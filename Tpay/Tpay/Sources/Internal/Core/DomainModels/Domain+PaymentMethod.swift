//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain {
    
    enum PaymentMethod: Equatable, Hashable {
        
        // MARK: - Cases
        
        case blik
        case pbl(Bank)
        case card
        case digitalWallet(DigitalWallet)
        case installmentPayments(InstallmentPayment)
        
        case unknown
    }
}

extension Domain.PaymentMethod {
    
    var order: Int {
        switch self {
        case .blik:
            return 2
        case .pbl:
            return 3
        case .card:
            return 1
        case .digitalWallet:
            return 0
        case .installmentPayments:
            return 4
        case .unknown:
            return .max
        }
    }
}
