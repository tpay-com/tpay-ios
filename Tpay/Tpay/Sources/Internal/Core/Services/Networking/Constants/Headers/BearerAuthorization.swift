//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct BearerAuthorization: HttpHeader {
    
    // MARK: - Properties
    
    let key = "Authorization"
    let value: String
    
    private let claims: AuthorizationClaims
    
    // MARK: - Initializers
    
    init(from claims: AuthorizationClaims) {
        self.claims = claims
        
        value = "Bearer " + claims.accessToken
    }
}
