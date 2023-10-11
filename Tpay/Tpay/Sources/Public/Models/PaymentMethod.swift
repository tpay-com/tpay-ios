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
    
    // MARK: - CaseIterable
    
    public static var allCases: [PaymentMethod] {
        [.card, .blik, .pbl, .digitalWallet(.applePay), .digitalWallet(.googlePay), .digitalWallet(.payPal)]
    }
}
