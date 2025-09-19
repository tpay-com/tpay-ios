//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIStackView {

    convenience init(arrangeVertically subviews: UIView...) {
        self.init(arrangedSubviews: subviews)
        axis = .vertical
        spacing = 4
    }
    
    convenience init(arrangeHorizontally subviews: UIView...) {
        self.init(arrangedSubviews: subviews)
        spacing = 4
    }

}
