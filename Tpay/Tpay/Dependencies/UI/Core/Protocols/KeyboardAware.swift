//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol KeyboardAware: UIView {
    
    func adjust(for payload: KeyboardAppearancePayload)
    
}
