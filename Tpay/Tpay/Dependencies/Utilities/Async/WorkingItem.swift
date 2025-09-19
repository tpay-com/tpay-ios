//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Abstraction over cancellable items
final class WorkingItem {
    
    // MARK: - Properties
    
    private var cancelAction: Action?
    
    // MARK: - Initializers
    
    /// Initialize object with task cancelation closure
    /// - Parameter cancelAction: 
    init(_ cancelAction: @escaping Action) {
        self.cancelAction = cancelAction
    }
    
    deinit {
        cancelAction?()
    }
    
    // MARK: - API
    
    /// Invoke object task cancellation
    func cancel() {
        cancelAction?()
        cancelAction = nil
    }
    
}
