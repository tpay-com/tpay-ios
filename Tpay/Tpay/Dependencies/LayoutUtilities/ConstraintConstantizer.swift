//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol ConstraintConstantizer: LayoutResult {
    
    // MARK: - API
    
    @discardableResult
    func with(constant: CGFloat) -> LayoutResult
    
}
