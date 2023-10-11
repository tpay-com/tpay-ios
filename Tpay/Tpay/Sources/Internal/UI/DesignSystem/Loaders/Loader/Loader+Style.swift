//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Loader {
    
    enum Style {
        
        // MARK: - Cases
        
        case `default`
        case large
        
        // MARK: - Properties
        
        var size: CGSize {
            switch self {
            case .default:
                return CGSize(width: 24, height: 24)
            case .large:
                return CGSize(width: 32, height: 32)
            }
        }
    }
}
