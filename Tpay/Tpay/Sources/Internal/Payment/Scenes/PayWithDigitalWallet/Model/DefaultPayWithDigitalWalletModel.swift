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
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction,
                     using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, paymentDataStore: resolver.resolve(), transactionService: transactionService)
    }
    
    init(for transaction: Domain.Transaction, paymentDataStore: PaymentDataStore, transactionService: TransactionService) {
        self.transaction = transaction
        self.paymentDataStore = paymentDataStore
        self.transactionService = transactionService
    }
    
    // MARK: - API
    
    func payWithApplePay(with token: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: token, then: then)
    }
}
