//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol AxisLayout {
    
    @discardableResult
    func center(with sibling: View) -> ConstraintMultiplier
    
    @discardableResult
    func center(with layoutGuide: LayoutGuide) -> ConstraintMultiplier
    
}
