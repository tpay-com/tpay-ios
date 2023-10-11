//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension AuthorizationController {
    
    struct Authorize: NetworkRequest {
        
        typealias ResponseType = Response
        
        // MARK: - Properties
        
        let resource = NetworkResource(url: URL(staticString: "/oauth/auth"), method: .post, contentType: .none, authorization: .basic)
    }
}
