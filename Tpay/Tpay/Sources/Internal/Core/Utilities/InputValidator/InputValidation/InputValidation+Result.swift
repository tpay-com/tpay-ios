//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension InputValidation {
    
    enum Result: Hashable {
        
        // MARK: - Cases
        
        case notDetermined
        case valid
        case invalid(InputValidationError)
        
    }
    
}
