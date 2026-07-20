//
//  Copyright © 2026 Tpay. All rights reserved.
//

final class SingleTransactionLock {

    // MARK: - Properties

    private(set) var transactionId: String?
    private(set) var paymentMethod: Domain.PaymentMethod?

    // MARK: - API

    func lock(transactionId: String, paymentMethod: Domain.PaymentMethod) {
        guard self.transactionId == nil else { return }
        self.transactionId = transactionId
        self.paymentMethod = paymentMethod
    }
}
