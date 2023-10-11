//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayDTO {
    
    struct BlikPaymentData: Encodable {
        
        // MARK: - Properties
        
        let blikToken: String?
        let aliases: Alias?
    }
}

extension PayDTO.BlikPaymentData {
    
    struct Alias: Encodable {
        
        // MARK: - Properties
        
        let value: String
        let type: AliasType
        
        let label: String?
        let key: String?
    }
}

extension PayDTO.BlikPaymentData.Alias {
    
    enum AliasType: String, Encodable {
        
        // MARK: - Cases
        
        case uId = "UID"
        case payId = "PAYID"
    }
}
