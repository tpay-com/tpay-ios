//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardTokenModel: PayWithCardTokenModel {
    
    // MARK: - Properties
        
    let cardTokens: [Domain.CardToken]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(for transaction: Domain.Transaction, with cardTokens: [Domain.CardToken], using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, with: cardTokens, transactionService: transactionService, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, with cardTokens: [Domain.CardToken], transactionService: TransactionService, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.cardTokens = cardTokens
        self.transactionService = transactionService
        self.transactionLock = transactionLock
    }
    
    // MARK: - API

    func invokePayment(with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: cardToken, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: cardToken, ignoreErrorsWhenContinueUrlExists: false, then: then)
        }
    }
}
