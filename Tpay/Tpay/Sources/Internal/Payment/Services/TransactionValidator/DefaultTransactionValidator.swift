//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

final class DefaultTransactionValidator: TransactionValidator {
    
    // MARK: - TransactionValidator
    
    func validate(transaction: Domain.OngoingTransaction) throws {
        guard let paymentErrors = transaction.paymentErrors,
              let errorToBeThrown = paymentErrors.sorted().first else {
            return
        }
        throw errorToBeThrown
    }
}
