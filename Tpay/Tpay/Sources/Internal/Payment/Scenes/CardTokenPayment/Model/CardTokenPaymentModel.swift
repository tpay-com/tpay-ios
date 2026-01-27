//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol CardTokenPaymentModel: AnyObject {
    
    // MARK: - Properties
    
    var onPaymentCompleted: Observable<TransactionId> { get }
    var onPaymentFailed: Observable<TransactionId> { get }
    var errorOcured: Observable<PaymentError> { get }
    var transactionWithUrlOccured: Observable<Domain.OngoingTransaction> { get }
    
    // MARK: - API
    
    func invokePayment()
}
