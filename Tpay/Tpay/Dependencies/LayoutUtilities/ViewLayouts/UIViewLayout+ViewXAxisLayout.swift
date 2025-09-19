//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension ViewLayout {
    
    final class ViewXAxisLayout: XAxisLayout {
        
        // MARK: - Properties
        
        private let anchor: LayoutAnchor.XAxis
        private let view: View
        private let invoker: Layout
        private let container: ConstraintsContainer
        
        // MARK: - Initialization
        
        init(for view: View, anchor: LayoutAnchor.XAxis, invoker: Layout, container: ConstraintsContainer) {
            self.view = view
            self.anchor = anchor
            self.invoker = invoker
            self.container = container
        }
        
        // MARK: - XAxisLayout
        
        func equalTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: self.anchor.attribute, relation: .equal, target: sibling, targetAttribute: anchor.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func lessThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: self.anchor.attribute, relation: .lessThanOrEqual, target: sibling, targetAttribute: anchor.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func greaterThanOrEqualTo(_ sibling: View, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: self.anchor.attribute, relation: .greaterThanOrEqual, target: sibling, targetAttribute: anchor.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func equalTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: self.anchor.attribute, relation: .equal, target: layoutGuide, targetAttribute: anchor.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func lessThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view, itemAttribute: self.anchor.attribute, relation: .lessThanOrEqual, target: layoutGuide, targetAttribute: anchor.attribute)
            return makePrioritizer(for: endorse(constraint))
        }
        
        func greaterThanOrEqualTo(_ layoutGuide: LayoutGuide, _ anchor: LayoutAnchor.XAxis) -> ConstraintMultiplier {
            let constraint = LayoutConstraint(item: view,
                                              itemAttribute: self.anchor.attribute,
                                              relation: .greaterThanOrEqual,
                                              target: layoutGuide,
                                              targetAttribute: anchor.attribute)
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
