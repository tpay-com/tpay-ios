//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithPayPoModel: PayWithPayPoModel {
    
    // MARK: - Properties
    
    let transaction: Domain.Transaction
    let merchantDetails: Domain.MerchantDetails
    
    private let transactionService: TransactionService
        
    // MARK: - Initializers
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else {
            preconditionFailure("Merchant details is not configured")
        }
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, transactionService: transactionService, merchantDetailsProvider: merchantDetailsProvider)
    }
    
    init(for transaction: Domain.Transaction, transactionService: TransactionService, merchantDetailsProvider: MerchantDetailsProvider) {
        self.transaction = transaction
        self.transactionService = transactionService
        self.merchantDetails = Domain.MerchantDetails(displayName: merchantDetailsProvider.merchantDisplayName(for: .current),
                                                      headquarters: merchantDetailsProvider.merchantHeadquarters(for: .current),
                                                      regulationsUrl: merchantDetailsProvider.regulationsLink(for: .current))
    }
    
    // MARK: - API

    func invokePayment(with payPoPayer: Domain.Payer, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: payPoPayer, then: then)
    }
}
