//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TextField.CVC {
    
    enum Kind {
        
        // MARK: - Cases
        
        case fourDigit
        case threeDigit
        
        // MARK: - Getters
        
        var numberOfCharacters: Int {
            switch self {
            case .fourDigit: return 4
            case .threeDigit: return 3
            }
        }
    }
}
