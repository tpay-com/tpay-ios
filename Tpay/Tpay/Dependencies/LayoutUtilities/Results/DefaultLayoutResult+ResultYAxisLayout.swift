//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension DefaultLayoutResult {
    
    final class ResultYAxisLayout: YAxisLayout {
        
        // MARK: - Properties
        
        private let anchor: LayoutAnchor.YAxis
        private let invoker: Layout
        
        private var invokerLayout: YAxisLayout {
            switch anchor {
            case .top: return invoker.top
            case .bottom: return invoker.bottom
            }
        }
        
        // MARK: - Initialization
        
        init(anchor: LayoutAnchor.YAxis, invoker: Layout) {
            self.anchor = anchor
            self.invoker = invoker
        }
        
        // MARK: - YAxisLayout
        
        func equalTo(_ sibling: View, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.equalTo(sibling, anchor)
        }
        
        func lessThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.lessThanOrEqualTo(sibling, anchor)
        }
        
        func greaterThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.greaterThanOrEqualTo(sibling, anchor)
        }
        
        func equalTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.equalTo(layoutGuide, anchor)
        }
        
        func lessThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.lessThanOrEqualTo(layoutGuide, anchor)
        }
        
        func greaterThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.YAxis) -> ConstraintMultiplier {
            invokerLayout.greaterThanOrEqualTo(layoutGuide, anchor)
        }
        
    }
    
}
