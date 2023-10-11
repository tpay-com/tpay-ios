//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol CardTokenPaymentModel: AnyObject {
    
    // MARK: - Properties
    
    var onPaymentCompleted: Observable<TransactionId> { get }
    var onPaymentFailed: Observable<TransactionId> { get }
    var errorOcured: Observable<PaymentError> { get }
    
    // MARK: - API
    
    func invokePayment()
}
