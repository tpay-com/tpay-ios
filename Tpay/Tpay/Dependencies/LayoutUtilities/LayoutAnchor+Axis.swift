//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension LayoutAnchor {
    
    enum Axis {
        
        case xAxis
        case yAxis
        
        var attribute: NSLayoutConstraint.Attribute {
            switch self {
            case .xAxis: return .centerX
            case .yAxis: return .centerY
            }
        }
        
    }
    
}
