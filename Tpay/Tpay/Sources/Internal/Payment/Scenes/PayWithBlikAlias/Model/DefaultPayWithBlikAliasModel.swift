//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikAliasModel: PayWithBlikAliasModel {
    
    // MARK: - Properties
    
    let blikAlias: Domain.Blik.OneClick.Alias
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
        
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, with blikAlias: Domain.Blik.OneClick.Alias, using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(for: transaction, with: blikAlias, transactionService: transactionService)
    }
    
    init(for transaction: Domain.Transaction, with blikAlias: Domain.Blik.OneClick.Alias, transactionService: TransactionService) {
        self.transaction = transaction
        self.blikAlias = blikAlias
        self.transactionService = transactionService
    }
    
    // MARK: - API
    
    func invokePayment(with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: blik, then: then)
    }
}
