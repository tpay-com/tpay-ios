//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithRatyPekaoModel: PayWithRatyPekaoModel {
    
    // MARK: - Properties
    
    let installmentPayments: [Domain.PaymentMethod.InstallmentPayment]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        let transactionService = DefaultTransactionService(using: resolver)
        let paymentMethodsService: PaymentMethodsService = resolver.resolve()
        self.init(for: transaction, paymentMethodsService: paymentMethodsService, transactionService: transactionService)
    }
    
    init(for transaction: Domain.Transaction, paymentMethodsService: PaymentMethodsService, transactionService: TransactionService) {
        self.transaction = transaction
        self.transactionService = transactionService
        installmentPayments = paymentMethodsService.resolveAvailablePaymentMethods(for: transaction).allInstallmentPayments()
    }
    
    // MARK: - API
    
    func invokePayment(with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: installmentPayment, then: then)
    }
}
