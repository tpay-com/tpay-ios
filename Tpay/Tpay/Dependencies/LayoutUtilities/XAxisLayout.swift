//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol XAxisLayout {
    
    @discardableResult
    func equalTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    @discardableResult
    func lessThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    @discardableResult
    func greaterThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    
    @discardableResult
    func equalTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    @discardableResult
    func lessThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    @discardableResult
    func greaterThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier
    
}
