//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct BasicAuthorization: HttpHeader {
    
    // MARK: - Properties
    
    let key = "Authorization"
    let value: String
    
    private let user: String
    private let password: String
    
    // MARK: - Lifecycle

    init(for credentials: AuthorizationCredentials) {
        user = credentials.user
        password = credentials.password
        
        value = "Basic " + (user + ":" + password).base64
    }
}
