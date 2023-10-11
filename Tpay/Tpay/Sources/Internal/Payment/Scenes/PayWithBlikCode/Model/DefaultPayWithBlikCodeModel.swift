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
    private lazy var mapper = DefaultAPIToDomainModelsMapper()
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        self.init(transactionService: transactionService, configurationProvider: resolver.resolve())
    }
    
    init(transactionService: TransactionService, configurationProvider: ConfigurationProvider) {
        self.transactionService = transactionService
        self.configurationProvider = configurationProvider
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: blik, then: then)
    }
}
