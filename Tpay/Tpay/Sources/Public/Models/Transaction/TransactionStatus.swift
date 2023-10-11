//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `TransactionStatus` enum represents different statuses that a transaction can have.

public enum TransactionStatus {
    
    // MARK: - Cases
    
    case pending
    case paid
    case correct
    case refund
    case error
    case unknown
}
