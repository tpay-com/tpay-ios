//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain {
    
    struct Card {
        
        // MARK: - Properties
        
        let number: String
        let expiryDate: ExpiryDate
        let securityCode: String
        
        let shouldTokenize: Bool
    }
}
