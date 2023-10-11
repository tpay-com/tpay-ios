//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Merchant {
    
    // MARK: - Properties
    
    var domain: String { "https://tpay.com" }
    
    var successCallbackUrl: URL { URL(safeString: "https://127.0.0.1/success/") }
    var errorCallbackUrl: URL { URL(safeString: "https://127.0.0.1/error/") }
    var validationUrl: URL { URL(safeString: "https://127.0.0.1/validation/") }
    
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
