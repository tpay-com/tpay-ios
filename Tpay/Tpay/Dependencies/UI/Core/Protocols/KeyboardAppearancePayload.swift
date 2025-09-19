//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

struct KeyboardAppearancePayload {
    
    // MARK: - Properties
    
    let mode: Mode
    let height: CGFloat
    let animationDuration: Double
    let animationOptions: UIView.AnimationOptions
    
}

extension KeyboardAppearancePayload {
    
    enum Mode {
        
        case appearing
        case disappearing
        
    }
    
}
