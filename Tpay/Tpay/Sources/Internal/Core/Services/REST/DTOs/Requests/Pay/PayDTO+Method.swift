//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayWithInstantRedirectionDTO {
    
    enum Method: String, Encodable {
        
        // MARK: - Cases
        
        case payByLink = "pay_by_link"
        case transfer
        case sale
    }
}
