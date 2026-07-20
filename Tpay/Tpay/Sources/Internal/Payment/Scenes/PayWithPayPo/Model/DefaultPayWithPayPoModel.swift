//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithPayPoModel: PayWithPayPoModel {
    
    // MARK: - Properties
    
    let transaction: Domain.Transaction
    let merchantDetails: Domain.MerchantDetails
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else {
            preconditionFailure("Merchant details is not configured")
        }
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, transactionService: transactionService, merchantDetailsProvider: merchantDetailsProvider, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, transactionService: TransactionService, merchantDetailsProvider: MerchantDetailsProvider, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.transactionService = transactionService
        self.transactionLock = transactionLock
        self.merchantDetails = Domain.MerchantDetails(displayName: merchantDetailsProvider.merchantDisplayName(for: .current),
                                                      headquarters: merchantDetailsProvider.merchantHeadquarters(for: .current),
                                                      regulationsUrl: merchantDetailsProvider.regulationsLink(for: .current))
    }
    
    // MARK: - API

    func invokePayment(with payPoPayer: Domain.Payer, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePaymentForPayPo(for: ongoingTransaction, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: payPoPayer, then: then)
        }
    }
}
