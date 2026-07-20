//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikAliasModel: PayWithBlikAliasModel {
    
    // MARK: - Properties
    
    let blikAlias: Domain.Blik.OneClick.Alias
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(for transaction: Domain.Transaction, with blikAlias: Domain.Blik.OneClick.Alias, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, with: blikAlias, transactionService: transactionService, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, with blikAlias: Domain.Blik.OneClick.Alias, transactionService: TransactionService, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.blikAlias = blikAlias
        self.transactionService = transactionService
        self.transactionLock = transactionLock
    }
    
    // MARK: - API
    
    func invokePayment(with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: blik, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: blik, then: then)
        }
    }
}
