//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

final class LayoutGuideLayout: LayoutConfiguration, Layout {

    // MARK: - Properties
    
    var xAxis: AxisLayout { LayoutGuideAxisLayout(for: layoutGuide, axis: .xAxis, invoker: self, container: container) }
    var yAxis: AxisLayout { LayoutGuideAxisLayout(for: layoutGuide, axis: .yAxis, invoker: self, container: container) }
    
    var width: DimensionLayout { LayoutGuideDimensionLayout(for: layoutGuide, anchor: .width, invoker: self, container: container) }
    var height: DimensionLayout { LayoutGuideDimensionLayout(for: layoutGuide, anchor: .height, invoker: self, container: container) }
    
    var leading: XAxisLayout { LayoutGuideXAxisLayout(for: layoutGuide, anchor: .leading, invoker: self, container: container) }
    var trailing: XAxisLayout { LayoutGuideXAxisLayout(for: layoutGuide, anchor: .trailing, invoker: self, container: container) }
    
    var top: YAxisLayout { LayoutGuideYAxisLayout(for: layoutGuide, anchor: .top, invoker: self, container: container) }
    var bottom: YAxisLayout { LayoutGuideYAxisLayout(for: layoutGuide, anchor: .bottom, invoker: self, container: container) }
    
    private let layoutGuide: LayoutGuide
    private let container: ConstraintsContainer
    
    // MARK: - Initializers
    
    convenience init(of layoutGuide: LayoutGuide) {
        self.init(for: layoutGuide, with: DefaultConstraintsContainer())
    }
    
    init(for layoutGuide: LayoutGuide, with container: ConstraintsContainer) {
        self.layoutGuide = layoutGuide
        self.container = container
    }
    
    // MARK: - LayoutConfiguration

    func embed(in view: View) -> Self {
        embed(in: view, with: NSDirectionalEdgeInsets())
    }

    func embed(in guide: LayoutGuide) -> Self {
        embed(in: guide, with: NSDirectionalEdgeInsets())
    }

    @discardableResult
    func embed(in view: View, with margin: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets()) -> Self {
        leading.equalTo(view, .leading).with(constant: margin.leading)
        trailing.equalTo(view, .trailing).with(constant: -margin.trailing)
        top.equalTo(view, .top).with(constant: margin.top)
        bottom.equalTo(view, .bottom).with(constant: -margin.bottom)
        return self
    }

    @discardableResult
    func embed(in guide: LayoutGuide, with margin: NSDirectionalEdgeInsets) -> Self {
        leading.equalTo(guide, .leading).with(constant: margin.leading)
        trailing.equalTo(guide, .trailing).with(constant: -margin.trailing)
        top.equalTo(guide, .top).with(constant: margin.top)
        bottom.equalTo(guide, .bottom).with(constant: -margin.bottom)
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
    
    @discardableResult
    func add(to parent: View) -> Self {
        parent.addLayoutGuide(layoutGuide)
        return self
    }
    
    func activate() -> Self {
        container.activate()
        return self
    }
    
}
