//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Domain.CardToken.Brand {
    
    // MARK: - Properties
    
    var image: UIImage {
        switch self {
        case .mastercard:
            return Asset.Icons.mastercardLogo.image
        case .visa:
            return Asset.Icons.visaLogo.image
        case .other:
            return .init()
        }
    }
}
