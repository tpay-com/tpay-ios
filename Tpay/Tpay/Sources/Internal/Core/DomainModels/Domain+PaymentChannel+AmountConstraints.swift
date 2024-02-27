//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

protocol AmountConstraint {
    func isSatisfied(by value: Double) -> Bool
}

extension Domain.PaymentChannel {
    
    struct MinAmountConstraint: AmountConstraint {
        let minValue: Double
        func isSatisfied(by value: Double) -> Bool {
            value >= self.minValue
        }
    }

    struct MaxAmountConstraint: AmountConstraint {
        let maxValue: Double
        func isSatisfied(by value: Double) -> Bool {
            value <= self.maxValue
        }
    }
    
    func testAvailabilityAgainst(paymentInfo: Domain.PaymentInfo) -> Bool {
        amountConstraints
            .allSatisfy { $0.isSatisfied(by: paymentInfo.amount) }
    }
}
