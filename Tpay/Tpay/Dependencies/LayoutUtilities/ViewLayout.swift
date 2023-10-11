//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

final class ViewLayout: ViewLayoutConfiguration, Layout {

    // MARK: - Properties
    
    var xAxis: AxisLayout { ViewAxisLayout(for: view, axis: .xAxis, invoker: self, container: container) }
    var yAxis: AxisLayout { ViewAxisLayout(for: view, axis: .yAxis, invoker: self, container: container) }
    
    var width: DimensionLayout { ViewDimensionLayout(for: view, anchor: .width, invoker: self, container: container) }
    var height: DimensionLayout { ViewDimensionLayout(for: view, anchor: .height, invoker: self, container: container) }
    
    var leading: XAxisLayout { ViewXAxisLayout(for: view, anchor: .leading, invoker: self, container: container) }
    var trailing: XAxisLayout { ViewXAxisLayout(for: view, anchor: .trailing, invoker: self, container: container) }
    
    var top: YAxisLayout { ViewYAxisLayout(for: view, anchor: .top, invoker: self, container: container) }
    var bottom: YAxisLayout { ViewYAxisLayout(for: view, anchor: .bottom, invoker: self, container: container) }
    
    private let view: View
    private let container: ConstraintsContainer
    
    // MARK: - Initializers
    
    convenience init(of view: View) {
        self.init(for: view, with: DefaultConstraintsContainer())
    }
    
    init(for view: View, with container: ConstraintsContainer) {
        self.view = view
        self.container = container
    }
    
    // MARK: - LayoutConfiguration
    
    @discardableResult
    func add(to parent: View) -> Self {
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    // MARK: - ViewLayoutConfiguration
    
    @discardableResult
    func add(subviews: View...) -> ViewLayoutConfiguration {
        add(subviews: subviews)
        return self
    }
    
    // MARK: - Layout
    
    func add(subviews: [View]) {
        subviews.forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
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

}
