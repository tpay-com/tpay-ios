//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol ConstraintMultiplier: ConstraintPrioritizer {
    
    // MARK: - API
    
    @discardableResult
    func multiplied(by multiplier: CGFloat) -> ConstraintPrioritizer
    
}
