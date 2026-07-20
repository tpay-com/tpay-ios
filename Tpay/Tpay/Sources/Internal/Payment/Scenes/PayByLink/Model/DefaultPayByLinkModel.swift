//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayByLinkModel: PayByLinkModel {
    
    // MARK: - Properties
    
    let banks: [Domain.PaymentMethod.Bank]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        let banksService: BanksService = resolver.resolve()
        self.init(for: transaction, banksService: banksService, transactionService: transactionService, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, banksService: BanksService, transactionService: TransactionService, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.transactionService = transactionService
        self.transactionLock = transactionLock
        banks = banksService.banks.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    // MARK: - API
    
    func invokePayment(with bank: Domain.PaymentMethod.Bank, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: bank, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: bank, then: then)
        }
    }
}
