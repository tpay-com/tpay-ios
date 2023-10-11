//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingPaymentModel: ProcessingPaymentModel {
    
    // MARK: - Properties
    
    var status: Observable<Domain.OngoingTransaction.Status> { transactionObserver.status }
    
    private let transactionObserver: TransactionObserver
    
    // MARK: - Initializers
    
    init(transaction: Domain.OngoingTransaction, resolver: ServiceResolver) {
        transactionObserver = DefaultTransactionObserver(transaction: transaction, resolver: resolver)
    }
    
    // MARK: - API
    
    func startObserving() {
        transactionObserver.startObserving()
    }
    
    func stopObserving() {
        transactionObserver.stopObserving()
    }
}
