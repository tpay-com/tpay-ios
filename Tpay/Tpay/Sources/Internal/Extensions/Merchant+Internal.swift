//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Merchant {
    
    // MARK: - Properties
    
    var domain: String { "https://tpay.com" }
    
    var successCallbackUrl: URL { URL(safeString: "https://secure.tpay.com/mobile-sdk/success/") }
    var errorCallbackUrl: URL { URL(safeString: "https://secure.tpay.com/mobile-sdk/error/") }
    var validationUrl: URL { URL(safeString: "https://secure.tpay.com/mobile-sdk/validation/") }
    
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
