//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    enum State {
        
        // MARK: - Cases
        
        case enabled
        case active
        case filled
        case disabled
        case error
        
        // MARK: - Getters
        
        var borderColor: UIColor {
            switch self {
            case .enabled, .filled, .disabled:
                return DesignSystem.Colors.Neutral._200.color
            case .active:
                return DesignSystem.Colors.Primary._500.color
            case .error:
                return DesignSystem.Colors.Semantic.error.color
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .disabled:
                return DesignSystem.Colors.Neutral._100.color
            default:
                return DesignSystem.Colors.Neutral.white.color
            }
        }
    }
}
