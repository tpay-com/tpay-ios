//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension NSLayoutConstraint {

    convenience init(wrapping prototype: LayoutConstraint) {
        self.init(item: prototype.item,
                  attribute: prototype.itemAttribute,
                  relatedBy: prototype.relation,
                  toItem: prototype.target,
                  attribute: prototype.targetAttribute,
                  multiplier: prototype.multiplier,
                  constant: prototype.constant)
        if let priority = prototype.priority {
            self.priority = priority
        }
    }

}
