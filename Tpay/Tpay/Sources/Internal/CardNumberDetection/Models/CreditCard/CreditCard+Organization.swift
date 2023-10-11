//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension CardNumberDetectionModels.CreditCard {
    
    enum Brand {
        
        // MARK: - Cases
        
        case mastercard
        case visa
        case other
        
        // MARK: - Properties
        
        var logo: UIImage? {
            switch self {
            case .mastercard:
                return DesignSystem.Icons.mastercardLogo.image
            case .visa:
                return DesignSystem.Icons.visaLogo.image
            default:
                return nil
            }
        }
    }
}
