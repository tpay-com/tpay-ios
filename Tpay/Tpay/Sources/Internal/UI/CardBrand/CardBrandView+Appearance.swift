//
//  Copyright © 2022 Tpay. All rights reserved.
//

import CoreGraphics
import UIKit

extension CardBrandView {
    
    enum Appearance {
        
        // MARK: - Cases
        
        case large
        case small
        
        // MARK: - Properties
        
        var intrinsicContentSize: CGSize {
            switch self {
            case .large:
                return .init(width: 35, height: 24)
            case .small:
                return .init(width: 23, height: 16)
            }
        }
        
        var offset: UIOffset {
            switch self {
            case .large:
                return .init(horizontal: 5, vertical: 5)
            case .small:
                return .init(horizontal: 4, vertical: 4)
            }
        }
    }
}
