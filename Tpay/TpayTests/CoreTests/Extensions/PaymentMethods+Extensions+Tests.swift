//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PaymentMethods_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_GetAllBanks() {
        let paymentMethods = Stub.paymentMethods
        
        expect(paymentMethods.allBanks()) == [
            Domain.PaymentMethod.Bank(id: "1", name: "1", imageUrl: nil),
            Domain.PaymentMethod.Bank(id: "2", name: "2", imageUrl: nil),
            Domain.PaymentMethod.Bank(id: "3", name: "3", imageUrl: nil)
        ]
        expect(paymentMethods.allBanks().count) == 3
    }
}

private extension PaymentMethods_Extensions_Tests {
    
    enum Stub {
        
        static let paymentMethods: [Domain.PaymentMethod] = [.blik, .card, .digitalWallet(.applePay), .pbl(Domain.PaymentMethod.Bank(id: "1", name: "1", imageUrl: nil)), .pbl(Domain.PaymentMethod.Bank(id: "2", name: "2", imageUrl: nil)), .pbl(Domain.PaymentMethod.Bank(id: "3", name: "3", imageUrl: nil))]
    }
}
