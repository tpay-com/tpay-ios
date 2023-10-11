//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct AuthorizationClaims {
    
    // MARK: - Properties
    
    let accessToken: String
    let refreshToken: String?
    
    // MARK: - Initializers
    
    init(accessToken: String) {
        self.accessToken = accessToken
        refreshToken = nil
    }
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
