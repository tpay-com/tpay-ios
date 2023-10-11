//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension DefaultLayoutResult {
    
    final class ResultAxisLayout: AxisLayout {
        
        // MARK: - Properties
        
        private let axis: LayoutAnchor.Axis
        private let invoker: Layout
        
        // MARK: - Initialization
        
        init(axis: LayoutAnchor.Axis, invoker: Layout) {
            self.axis = axis
            self.invoker = invoker
        }
        
        // MARK: - AxisLayout
        
        func center(with sibling: View) -> ConstraintMultiplier {
            switch axis {
            case .xAxis: return invoker.xAxis.center(with: sibling)
            case .yAxis: return invoker.yAxis.center(with: sibling)
            }
        }
        
        func center(with layoutGuide: LayoutGuide) -> ConstraintMultiplier {
            switch axis {
            case .xAxis: return invoker.xAxis.center(with: layoutGuide)
            case .yAxis: return invoker.yAxis.center(with: layoutGuide)
            }
        }
        
    }
    
}
