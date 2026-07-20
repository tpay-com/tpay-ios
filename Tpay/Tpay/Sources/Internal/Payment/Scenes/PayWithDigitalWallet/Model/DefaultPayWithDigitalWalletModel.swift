//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

final class DefaultPayWithDigitalWalletModel: PayWithDigitalWalletModel {
    
    // MARK: - Properties
    
    private(set) lazy var digitalWallets: [Domain.PaymentMethod.DigitalWallet] = paymentDataStore.paymentMethods.allWallets()
    
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let paymentDataStore: PaymentDataStore
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction,
                     using resolver: ServiceResolver,
                     transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, paymentDataStore: resolver.resolve(), transactionService: transactionService, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, paymentDataStore: PaymentDataStore, transactionService: TransactionService, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.paymentDataStore = paymentDataStore
        self.transactionService = transactionService
        self.transactionLock = transactionLock
    }
    
    // MARK: - API
    
    func payWithApplePay(with token: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: token, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: token, then: then)
        }
    }
}
