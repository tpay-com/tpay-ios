//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension LayoutAnchor {
    
    enum Dimension {
        
        case width
        case height
        
        var attribute: NSLayoutConstraint.Attribute {
            switch self {
            case .width: return .width
            case .height: return .height
            }
        }
        
    }
    
}
