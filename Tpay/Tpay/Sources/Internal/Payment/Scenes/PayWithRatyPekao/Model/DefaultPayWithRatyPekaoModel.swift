//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithRatyPekaoModel: PayWithRatyPekaoModel {
    
    // MARK: - Properties
    
    let installmentPayments: [Domain.PaymentMethod.InstallmentPayment]
    let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let transactionLock: SingleTransactionLock

    // MARK: - Initializers

    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        let transactionService = DefaultTransactionService(using: resolver)
        let paymentMethodsService: PaymentMethodsService = resolver.resolve()
        self.init(for: transaction, paymentMethodsService: paymentMethodsService, transactionService: transactionService, transactionLock: transactionLock)
    }

    init(for transaction: Domain.Transaction, paymentMethodsService: PaymentMethodsService, transactionService: TransactionService, transactionLock: SingleTransactionLock) {
        self.transaction = transaction
        self.transactionService = transactionService
        self.transactionLock = transactionLock
        installmentPayments = paymentMethodsService.resolveAvailablePaymentMethods(for: transaction).allInstallmentPayments()
    }
    
    // MARK: - API
    
    func invokePayment(with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler) {
        if let continuingTransactionId = transactionLock.transactionId {
            let ongoingTransaction = Domain.OngoingTransaction(transactionId: continuingTransactionId, status: .unknown, notification: nil, continueUrl: nil, paymentErrors: nil)
            transactionService.continuePayment(for: ongoingTransaction, with: installmentPayment, then: then)
        } else {
            transactionService.invokePayment(for: transaction, with: installmentPayment, then: then)
        }
    }
}
