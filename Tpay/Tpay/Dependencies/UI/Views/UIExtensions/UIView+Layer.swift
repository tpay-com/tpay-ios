//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundTopCorners(by value: CGFloat) {
        round([.topLeft, .topRight], by: value)
    }
    
    func round(_ corners: UIRectCorner, by value: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: value, height: value))
        layer.mask = CAShapeLayer(path: path.cgPath)
    }
    
}
