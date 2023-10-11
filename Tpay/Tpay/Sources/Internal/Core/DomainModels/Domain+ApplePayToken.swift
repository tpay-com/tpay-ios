//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain {
    
    struct ApplePayToken {
        
        // MARK: - Properties
        
        let token: String
        
        // MARK: - Initializers
        
        init(token: String) {
            self.token = token
        }
    }
}
