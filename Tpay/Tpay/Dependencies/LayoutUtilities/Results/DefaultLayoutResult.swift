//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

final class DefaultLayoutResult: ConstraintMultiplier {

    // MARK: - Properties
    
    private let invoker: Layout
    private let container: ConstraintsContainer
    private let constraintPrototype: LayoutConstraint
    
    // MARK: - Getters
    
    var constraint: NSLayoutConstraint { container.getConstraint(for: constraintPrototype) }
    var constraints: [NSLayoutConstraint] {
        container.getConstraints()
    }
    
    var xAxis: AxisLayout { ResultAxisLayout(axis: .xAxis, invoker: invoker) }
    var yAxis: AxisLayout { ResultAxisLayout(axis: .yAxis, invoker: invoker) }
    
    var width: DimensionLayout { ResultDimensionLayout(anchor: .width, invoker: invoker) }
    var height: DimensionLayout { ResultDimensionLayout(anchor: .height, invoker: invoker) }
    
    var leading: XAxisLayout { ResultXAxisLayout(anchor: .leading, invoker: invoker) }
    var trailing: XAxisLayout { ResultXAxisLayout(anchor: .trailing, invoker: invoker) }
    
    var top: YAxisLayout { ResultYAxisLayout(anchor: .top, invoker: invoker) }
    var bottom: YAxisLayout { ResultYAxisLayout(anchor: .bottom, invoker: invoker) }
    
    // MARK: - InitializersLayout
    
    init(constraint: LayoutConstraint, invoker: Layout, container: ConstraintsContainer) {
        constraintPrototype = constraint
        self.invoker = invoker
        self.container = container
    }
    
    // MARK: - Layout
    
    func activate() -> Self {
        container.activate()
        return self
    }

    func embed(in view: View) -> Self {
        embed(in: view, with: NSDirectionalEdgeInsets())
    }

    func embed(in guide: LayoutGuide) -> Self {
        embed(in: guide, with: NSDirectionalEdgeInsets())
    }

    func embed(in view: View, with margin: NSDirectionalEdgeInsets) -> Self {
        leading.equalTo(view, .leading).with(constant: margin.leading)
        trailing.equalTo(view, .trailing).with(constant: -margin.trailing)
        top.equalTo(view, .top).with(constant: margin.top)
        bottom.equalTo(view, .bottom).with(constant: -margin.bottom)
        return self
    }

    func embed(in view: LayoutGuide, with margin: NSDirectionalEdgeInsets) -> Self {
        leading.equalTo(view, .leading).with(constant: margin.leading)
        trailing.equalTo(view, .trailing).with(constant: -margin.trailing)
        top.equalTo(view, .top).with(constant: margin.top)
        bottom.equalTo(view, .bottom).with(constant: -margin.bottom)
        return self
    }

    #if os(iOS)

    func embed(in view: View, with margin: UIEdgeInsets) -> Self {
        leading.equalTo(view, .leading).with(constant: margin.left)
        trailing.equalTo(view, .trailing).with(constant: -margin.right)
        top.equalTo(view, .top).with(constant: margin.top)
        bottom.equalTo(view, .bottom).with(constant: -margin.bottom)
        return self
    }

    func embed(in guide: LayoutGuide, with margin: UIEdgeInsets) -> Self {
        let leadingMargin = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? margin.left : margin.right
        let trailingMargin = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? margin.right : margin.left

        leading.equalTo(guide, .leading).with(constant: leadingMargin)
        trailing.equalTo(guide, .trailing).with(constant: -trailingMargin)
        top.equalTo(guide, .top).with(constant: margin.top)
        bottom.equalTo(guide, .bottom).with(constant: -margin.bottom)

        return self
    }

    #endif
    
    // MARK: - ConstraintMultiplier
    
    func multiplied(by multiplier: CGFloat) -> ConstraintPrioritizer {
        constraintPrototype.set(multiplier: multiplier)
        return self
    }
    
    // MARK: - ConstraintPrioritizer
    
    func with(priority: LayoutPriority) -> ConstraintConstantizer {
        constraintPrototype.set(priority: priority)
        return self
    }
    
    func with(priority: Float) -> ConstraintConstantizer {
        constraintPrototype.set(priority: .init(priority))
        return self
    }
    
    // MARK: - ConstraintConstantizer
    
    func with(constant: CGFloat) -> LayoutResult {
        constraintPrototype.set(constant: constant)
        return self
    }
    
}
