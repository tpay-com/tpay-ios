//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `AddCardDelegate` protocol defines the methods that a delegate should implement to handle events related to card tokenization.

public protocol AddCardDelegate: AnyObject {
    
    // MARK: - API
    
    /// Notifies the delegate when the card tokenization process has been successfully completed.
    
    func onTokenizationCompleted()
    
    /// Notifies the delegate when the card tokenization process has been cancelled or encountered an error.

    func onTokenizationCancelled()
}
