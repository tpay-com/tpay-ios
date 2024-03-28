//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingPaymentWithUrlModel: ProcessingPaymentWithUrlModel {
    
    // MARK: - Events
    
    var status: Observable<Domain.OngoingTransaction.Status> { transactionObserver.status }
    
    // MARK: - Properties
    
    let continueUrl: URL
    let successUrl: URL
    let errorUrl: URL
    
    private let transactionObserver: TransactionObserver
        
    // MARK: - Initializers
    
    init(transaction: Domain.OngoingTransaction, resolver: ServiceResolver) {
        guard let continueUrl = transaction.continueUrl else { preconditionFailure("Continue url should be available here") }
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        
        self.continueUrl = continueUrl
        self.successUrl = configurationProvider.callbacksConfiguration.successRedirectUrl
        self.errorUrl = configurationProvider.callbacksConfiguration.errorRedirectUrl
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
