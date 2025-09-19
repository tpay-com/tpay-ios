//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension ViewLayout {
    
    final class ViewAxisLayout: AxisLayout {
        
        // MARK: - Properties
        
        private let axis: LayoutAnchor.Axis
        private let view: View
        private let invoker: Layout
        private let container: ConstraintsContainer
        
        // MARK: - Initialization
        
        init(for view: View, axis: LayoutAnchor.Axis, invoker: Layout, container: ConstraintsContainer) {
            self.view = view
            self.axis = axis
            self.invoker = invoker
            self.container = container
        }
        
        // MARK: - AxisLayout
        
        func center(with sibling: View) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: axis.attribute, relation: .equal, target: sibling, targetAttribute: axis.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func center(with layoutGuide: LayoutGuide) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: axis.attribute, relation: .equal, target: layoutGuide, targetAttribute: axis.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        // MARK: - Private
        
        private func endorse(_ constraint: LayoutConstraint) -> LayoutConstraint {
            container.add(constraint)
            return constraint
        }
        
        private func makePrioritizer(for constraint: LayoutConstraint) -> ConstraintMultiplier {
            DefaultLayoutResult(constraint: constraint, invoker: invoker, container: container)
        }
        
    }
    
}
