//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithAmbiguousBlikAliasesModel: PayWithAmbiguousBlikAliasesModel {
    
    // MARK: - Properties
    
    let blikAliases: [Domain.Blik.OneClick.Alias]
    let transaction: Domain.OngoingTransaction
    let transactionDetails: Domain.Transaction
    
    private let transactionService: TransactionService
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.OngoingTransaction,
                     with blikAliases: [Domain.Blik.OneClick.Alias],
                     transactionDetails: Domain.Transaction,
                     using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, with: blikAliases, transactionDetails: transactionDetails, transactionService: transactionService)
    }
    
    init(for transaction: Domain.OngoingTransaction,
         with blikAliases: [Domain.Blik.OneClick.Alias],
         transactionDetails: Domain.Transaction,
         transactionService: TransactionService) {
        self.transaction = transaction
        self.blikAliases = blikAliases
        self.transactionDetails = transactionDetails
        self.transactionService = transactionService
    }
    
    // MARK: - API
    
    func continuePayment(with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        transactionService.continuePayment(for: transaction, with: blik, then: then)
    }
}
