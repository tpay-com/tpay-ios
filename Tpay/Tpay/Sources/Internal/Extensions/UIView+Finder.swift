//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIView {
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        return allSubviews.first(where: { $0.isFirstResponder })
    }
    
    var allSubviews: [UIView] {
        subviews + subviews.flatMap { $0.allSubviews }
    }
    
    func allSubviews<T: UIView>(of type: T.Type) -> [T] {
        allSubviews.compactMap { $0 as? T }
    }
    
    func firstSubview<T: UIView>(of type: T.Type) -> T? {
        allSubviews(of: type).first
    }
}
