//
//  Copyright © 2023 Tpay. All rights reserved.
//

/// The `PaymentError` enum encompasses various errors related to payment processes.

public enum PaymentError: ModuleError {
    
    // MARK: - Cases
    
    case cannotMakeTransaction(description: String)
    case transactionWithError(description: String)
    case blikError(description: String)
    case unknown
}
