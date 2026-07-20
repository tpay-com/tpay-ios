//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation

extension Domain.OngoingTransaction {

    struct AttemptedPaymentError: LocalizedError {

        // MARK: - Properties

        let transactionId: String
        let underlying: Domain.OngoingTransaction.PaymentError

        // MARK: - LocalizedError

        var errorDescription: String? { underlying.errorDescription }
    }
}
