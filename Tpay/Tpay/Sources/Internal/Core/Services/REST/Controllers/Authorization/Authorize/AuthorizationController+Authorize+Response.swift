//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension AuthorizationController.Authorize {
    
    struct Response {
        
        // MARK: - Properties
        
        let accessToken: String
    }
}

extension AuthorizationController.Authorize.Response: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case accessToken = "access_token"
    }
    
}
