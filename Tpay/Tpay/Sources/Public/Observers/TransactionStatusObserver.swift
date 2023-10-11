//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `TransactionStatusObserver` protocol defines a method that an observer should implement to receive updates about transaction statuses.

public protocol TransactionStatusObserver: AnyObject {
    
    // MARK: - API
    
    /// Notifies the observer about changes in transaction status.
    /// - Parameter transactionStatus: The updated transaction status.
    
    func update(transactionStatus: TransactionStatus)
}
