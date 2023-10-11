//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol LayoutResult: Layout {
    
    // MARK: - Properties
    
    /// Last added constraint
    var constraint: NSLayoutConstraint { get }
    
    /// Added constraints
    ///
    /// - Warning: The array contains both inactive and active constrains. Calling `activate()` activates only previously added constraints.
    var constraints: [NSLayoutConstraint] { get }
    
    /// Activates previously added constraints and returns self
    ///
    /// - Returns: Layout result with cleared collection of constraints to activate
    @discardableResult
    func activate() -> Self
    
}
