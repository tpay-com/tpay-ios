//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CredentialsProvider: AnyObject {
    
    // MARK: - Properties
    
    var claims: AuthorizationClaims? { get }
    var credentials: AuthorizationCredentials? { get }
}
