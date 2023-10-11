//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol ConstraintPrioritizer: ConstraintConstantizer {
    
    // MARK: - API
    
    @discardableResult
    func with(priority: LayoutPriority) -> ConstraintConstantizer
    
    @discardableResult
    func with(priority: Float) -> ConstraintConstantizer
    
}
