//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CredentialsStore: AnyObject {
    
    // MARK: - API
    
    func store(claims: AuthorizationClaims)
    func store(credentials: AuthorizationCredentials)
    func removeClaims()
    func removeCredentials()
}
