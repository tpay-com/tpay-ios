//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayWithInstantRedirectionDTO {
    
    struct CardPaymentData: Encodable {
        
        // MARK: - Properties
        
        let card: String?
        let token: String?
        
        let shouldSave: Bool
    }
}

extension PayWithInstantRedirectionDTO.CardPaymentData {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case card
        case token
        
        case shouldSave = "save"
    }
}
