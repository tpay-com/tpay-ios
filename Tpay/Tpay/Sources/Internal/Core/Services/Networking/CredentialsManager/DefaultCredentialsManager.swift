//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultCredentialsManager: CredentialsManager {
    
    // MARK: - Properties
    
    var claims: AuthorizationClaims?
    var credentials: AuthorizationCredentials?
    
    // MARK: - API
    
    func store(claims: AuthorizationClaims) {
        self.claims = claims
    }
    
    func store(credentials: AuthorizationCredentials) {
        self.credentials = credentials
    }
    
    func removeClaims() {
        claims = nil
    }
    
    func removeCredentials() {
        credentials = nil
    }
}
