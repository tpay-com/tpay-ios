//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIView {
    
    func hide() { isHidden = true }
    
    func show() { isHidden = false }
    
    func sizeToFit(width: CGFloat) {
        frame.size = systemLayoutSizeFitting(CGSize(width: width, height: UIView.noIntrinsicMetric),
                                             withHorizontalFittingPriority: .required,
                                             verticalFittingPriority: .fittingSizeLevel)
    }
    
}
