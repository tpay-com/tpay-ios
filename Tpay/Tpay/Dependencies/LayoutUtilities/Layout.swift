//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

protocol Layout {
    
    // MARK: - Axis
    
    var xAxis: AxisLayout { get }
    var yAxis: AxisLayout { get }
    
    // MARK: - Dimension
    
    var width: DimensionLayout { get }
    var height: DimensionLayout { get }
    
    // MARK: - XAxis
    
    var leading: XAxisLayout { get }
    var trailing: XAxisLayout { get }
    
    // MARK: - YAxis
    
    var top: YAxisLayout { get }
    var bottom: YAxisLayout { get }
    
    // MARK: - API
    
    /// Activates previously added constraints and returns self
    ///
    /// - Returns: Layout with cleared collection of constraints to activate
    @discardableResult
    func activate() -> Self

    @discardableResult
    func embed(in view: View) -> Self

    @discardableResult
    func embed(in guide: LayoutGuide) -> Self

    @discardableResult
    func embed(in view: View, with margin: NSDirectionalEdgeInsets) -> Self

    @discardableResult
    func embed(in guide: LayoutGuide, with margin: NSDirectionalEdgeInsets) -> Self

    #if os(iOS)
    @discardableResult
    func embed(in view: View, with margin: UIEdgeInsets) -> Self

    @discardableResult
    func embed(in guide: LayoutGuide, with margin: UIEdgeInsets) -> Self
    #endif

}
