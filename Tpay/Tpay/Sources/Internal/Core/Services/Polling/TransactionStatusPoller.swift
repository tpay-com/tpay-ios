//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class TransactionStatusPoller: Poller<TransactionsController.SpecifiedTransaction> {
    
    // MARK: - Initializers
    
    init(for transactionId: String, using networkingService: NetworkingService) {
        let request = TransactionsController.SpecifiedTransaction(with: transactionId)
        super.init(for: request, using: networkingService)
    }
}
