//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    convenience init(path: CGPath) {
        self.init()
        self.path = path
    }
    
}
