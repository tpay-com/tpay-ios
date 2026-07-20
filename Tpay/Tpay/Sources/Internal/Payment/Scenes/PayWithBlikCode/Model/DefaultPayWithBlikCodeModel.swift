//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikCodeModel: PayWithBlikCodeModel {
    
    // MARK: - Properties
    
    var aliasToBeRegistered: Domain.Blik.Regular.Alias? {
        guard let alias = configurationProvider.merchant?.blikConfiguration?.aliasToBeRegistered else {
            return nil
        }
        return mapper.makeBlikAlias(from: alias)
    }
    
    private let transactionService: TransactionService
    private let configurationProvider: ConfigurationProvider
    private let transactionLock: SingleTransactionLock
    private lazy var mapper = DefaultAPIToDomainModelsMapper()
    
    // MARK: - Initializers

    convenience init(using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(transactionService: transactionService, configurationProvider: resolver.resolve(), transactionLock: transactionLock)
    }

    init(transactionService: TransactionService, configurationProvider: ConfigurationProvider, transactionLock: SingleTransactionLock) {
        self.transactionService = transactionService
        self.configurationProvider = configurationProvider
        self.transactionLock = transactionLock
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: blik, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: blik, then: then)
        }
    }
}
