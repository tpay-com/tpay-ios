//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayByLinkModel: PayByLinkModel {
    
    // MARK: - Properties
    
    let banks: [Domain.PaymentMethod.Bank]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        let banksService: BanksService = resolver.resolve()
        self.init(for: transaction, banksService: banksService, transactionService: transactionService)
    }
    
    init(for transaction: Domain.Transaction, banksService: BanksService, transactionService: TransactionService) {
        self.transaction = transaction
        self.transactionService = transactionService
        banks = banksService.banks.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    // MARK: - API
    
    func invokePayment(with bank: Domain.PaymentMethod.Bank, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: bank, then: then)
    }
}
