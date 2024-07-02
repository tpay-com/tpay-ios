//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `PaymentMethod` enum represents various payment methods available for transactions.

public enum PaymentMethod: CaseIterable, Equatable {
    
    // MARK: - Cases

    case card
    case blik
    case pbl
    case digitalWallet(DigitalWallet)
    case installmentPayments(InstallmentPayment)
    case payPo
    
    // MARK: - CaseIterable
    
    public static var allCases: [PaymentMethod] {
        [.card, .blik, .pbl, .digitalWallet(.applePay), .installmentPayments(.ratyPekao), .payPo]
    }
}
