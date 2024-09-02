//
//  Copyright © 2022 Tpay. All rights reserved.
//

///  The `PaymentDelegate` protocol defines the methods that a delegate should implement to handle payment-related events.

public protocol PaymentDelegate: AnyObject {
    
    // MARK: - API
    
    /// Notifies the delegate when a payment is created.
    /// - Parameter transactionId: The unique identifier for the created transaction.
    
    func onPaymentCreated(transactionId: TransactionId)
    
    /// Notifies the delegate when a payment is successfully completed.
    /// - Parameter transactionId: The unique identifier for the completed transaction.
    
    func onPaymentCompleted(transactionId: TransactionId)
    
    /// Notifies the delegate when a payment is cancelled by the user.
    /// - Parameter transactionId: The unique identifier for the cancelled transaction.
    
    func onPaymentCancelled(transactionId: TransactionId)
    
    /// Notifies the delegate when an error occurs during the payment process.
    /// - Parameter error: The error object describing the encountered issue.

    func onErrorOccured(error: ModuleError)
}
