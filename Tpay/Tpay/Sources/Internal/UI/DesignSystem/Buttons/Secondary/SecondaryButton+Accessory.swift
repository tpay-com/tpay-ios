//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button.Secondary {
    
    enum AccessoryAlignment {
        
        // MARK: - Cases
        
        case leading
        case trailing
        
        // MARK: - Properties
        
        var conentInsets: UIEdgeInsets {
            switch self {
            case .leading:
                return UIEdgeInsets(top: 11.5, left: 20, bottom: 11.5, right: 14.0)
            case .trailing:
                return UIEdgeInsets(top: 11.5, left: 14, bottom: 11.5, right: 14)
            }
        }
    }
}
