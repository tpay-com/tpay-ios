//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardModel: PayWithCardModel {
    
    // MARK: - Properties
    
    let merchantDetails: Domain.MerchantDetails
    
    private let transactionService: TransactionService
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else {
            preconditionFailure("Merchant details is not configured")
        }
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(transactionService: transactionService, merchantDetailsProvider: merchantDetailsProvider)
    }
    
    init(transactionService: TransactionService, merchantDetailsProvider: MerchantDetailsProvider) {
        self.transactionService = transactionService
        self.merchantDetails = Domain.MerchantDetails(displayName: merchantDetailsProvider.merchantDisplayName(for: .current),
                                                      headquarters: merchantDetailsProvider.merchantHeadquarters(for: .current),
                                                      regulationsUrl: merchantDetailsProvider.regulationsLink(for: .current))
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with card: Domain.Card, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: card, then: then)
    }
}
