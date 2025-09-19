//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

final class DefaultConstraintsContainer: ConstraintsContainer {
    
    // MARK: - Properties
    
    private var constraintPrototypes = [LayoutConstraint]()
    private var constraints = [NSLayoutConstraint]()
    
    // MARK: - ConstraintsContainer
    
    func add(_ constraint: LayoutConstraint) {
        constraintPrototypes.append(constraint)
    }
    
    func activate() {
        translateConstraintPrototypes()
        NSLayoutConstraint.activate(constraints)
    }
    
    func getConstraints() -> [NSLayoutConstraint] {
        translateConstraintPrototypes()
        return constraints
    }
    
    func getConstraint(for prototype: LayoutConstraint) -> NSLayoutConstraint{
        let constraint = map(prototype)
        constraints.append(constraint)
        return constraint
    }
    
    // MARK: - Private
    
    private func map(_ constraintPrototype: LayoutConstraint) -> NSLayoutConstraint {
        constraintPrototypes.removeAll(where: { suspect in suspect ===  constraintPrototype })
        return NSLayoutConstraint.init(wrapping: constraintPrototype)
    }
    
    private func translateConstraintPrototypes() {
        constraints.append(contentsOf: constraintPrototypes.map(NSLayoutConstraint.init(wrapping:)))
        constraintPrototypes.removeAll()
    }
    
}
