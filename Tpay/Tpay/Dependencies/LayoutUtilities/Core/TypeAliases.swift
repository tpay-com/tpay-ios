//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

#if canImport(UIKit)
    import UIKit
    typealias View = UIView
    typealias LayoutGuide = UILayoutGuide
    typealias LayoutPriority = UILayoutPriority
#else
    import AppKit
    typealias View = NSView
    typealias LayoutGuide = NSLayoutGuide
    typealias LayoutPriority = NSLayoutConstraint.Priority
#endif
