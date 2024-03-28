//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Merchant {
    
    // MARK: - Properties
    
    var domain: String { "https://tpay.com" }
    
    var scheme: String { "https" }
    var host: String {
        switch environment {
        case .production:
            return "api.tpay.com"
        case .sandbox:
            return "openapi.sandbox.tpay.com"
        }
    }
}
