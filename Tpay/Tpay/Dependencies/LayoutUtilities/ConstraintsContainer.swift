//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

protocol ConstraintsContainer {
    
    // MARK: - API

    func add(_ constraint: LayoutConstraint)
    func activate()
    
    func getConstraints() -> [NSLayoutConstraint]
    func getConstraint(for prototype: LayoutConstraint) -> NSLayoutConstraint
    
}
