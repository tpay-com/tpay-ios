//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardModel: PayWithCardModel {
    
    // MARK: - Properties
    
    let merchantDetails: Domain.MerchantDetails
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else {
            preconditionFailure("Merchant details is not configured")
        }
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(transactionService: transactionService, merchantDetailsProvider: merchantDetailsProvider, transactionLock: transactionLock)
    }

    init(transactionService: TransactionService, merchantDetailsProvider: MerchantDetailsProvider, transactionLock: SingleTransactionLock) {
        self.transactionService = transactionService
        self.transactionLock = transactionLock
        self.merchantDetails = Domain.MerchantDetails(displayName: merchantDetailsProvider.merchantDisplayName(for: .current),
                                                      headquarters: merchantDetailsProvider.merchantHeadquarters(for: .current),
                                                      regulationsUrl: merchantDetailsProvider.regulationsLink(for: .current))
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with card: Domain.Card, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: card, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: card, then: then)
        }
    }
}
