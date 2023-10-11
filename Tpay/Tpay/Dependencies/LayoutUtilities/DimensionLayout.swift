//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol DimensionLayout {
    
    @discardableResult
    func equalTo(constant: CGFloat) -> ConstraintMultiplier
    
    @discardableResult
    func lessThanOrEqualTo(constant: CGFloat) -> ConstraintMultiplier
    
    @discardableResult
    func greaterThanOrEqualTo(constant: CGFloat) -> ConstraintMultiplier
    
    @discardableResult
    func equalTo(_ sibling: View, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
    @discardableResult
    func lessThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
    @discardableResult
    func greaterThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
    @discardableResult
    func equalTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
    @discardableResult
    func lessThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
    @discardableResult
    func greaterThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.Dimension) -> ConstraintMultiplier
    
}
