//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol CardTokenPaymentRouter: AnyObject {
    
    // MARK: - Events
    
    var onPaymentCompleted: Observable<TransactionId> { get }
    var onPaymentFailed: Observable<TransactionId> { get }
    var onError: Observable<PaymentError> { get }
    var onTransactionWithUrl: Observable<Domain.OngoingTransaction> { get }
}

extension CardTokenPaymentRouter {
    
    // MARK: - API
    
    func invokeOnPaymentCompleted(transactionId: TransactionId) {
        onPaymentCompleted.on(.next(transactionId))
    }
    
    func invokeOnPaymentFailed(transactionId: TransactionId) {
        onPaymentFailed.on(.next(transactionId))
    }
    
    func invokeOnError(_ error: PaymentError) {
        onError.on(.next((error)))
    }
    
    func invokeOnTransactionUrl(ongoingTransaction: Domain.OngoingTransaction) {
        onTransactionWithUrl.on(.next((ongoingTransaction)))
    }
}
