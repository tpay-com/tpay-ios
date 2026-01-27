//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardTokenModel: PayWithCardTokenModel {
    
    // MARK: - Properties
        
    let cardTokens: [Domain.CardToken]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, with cardTokens: [Domain.CardToken], using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, with: cardTokens, transactionService: transactionService)
    }
    
    init(for transaction: Domain.Transaction, with cardTokens: [Domain.CardToken], transactionService: TransactionService) {
        self.transaction = transaction
        self.cardTokens = cardTokens
        self.transactionService = transactionService
    }
    
    // MARK: - API

    func invokePayment(with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: cardToken, ignoreErrorsWhenContinueUrlExists: false, then: then)
    }
}
