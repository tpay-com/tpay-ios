//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultCardTokenPaymentRouter: CardTokenPaymentRouter {
    
    // MARK: - Events
    
    var onPaymentCompleted = Observable<TransactionId>()
    var onPaymentFailed = Observable<TransactionId>()
    let onError = Observable<PaymentError>()
    let onTransactionWithUrl = Observable<Domain.OngoingTransaction>()
}
