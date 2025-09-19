//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension DefaultLayoutResult {
    
    final class ResultXAxisLayout: XAxisLayout {
        
        // MARK: - Properties
        
        private let anchor: LayoutAnchor.XAxis
        private let invoker: Layout
        
        private var invokerLayout: XAxisLayout {
            switch anchor {
            case .leading: return invoker.leading
            case .trailing: return invoker.trailing
            }
        }
        
        // MARK: - Initialization
        
        init(anchor: LayoutAnchor.XAxis, invoker: Layout) {
            self.anchor = anchor
            self.invoker = invoker
        }
        
        // MARK: - XAxisLayout
        
        func equalTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.equalTo(sibling, anchor)
        }
        
        func lessThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.lessThanOrEqualTo(sibling, anchor)
        }
        
        func greaterThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.greaterThanOrEqualTo(sibling, anchor)
        }
        
        func equalTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.equalTo(layoutGuide, anchor)
        }
        
        func lessThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.lessThanOrEqualTo(layoutGuide, anchor)
        }
        
        func greaterThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            invokerLayout.greaterThanOrEqualTo(layoutGuide, anchor)
        }
        
    }
    
}
