//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct AuthorizationCredentials {
    
    // MARK: - Properties
    
    let user: String
    let password: String
    
    // MARK: - Initializers
    
    init(user: String, password: String) {
        self.user = user
        self.password = password
    }
}
