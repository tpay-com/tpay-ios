//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayDTO {
    
    struct CardPaymentData: Encodable {
        
        // MARK: - Properties
        
        let card: String?
        let token: String?
        
        let shouldSave: Bool
    }
}

extension PayDTO.CardPaymentData {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case card
        case token
        
        case shouldSave = "save"
    }
}
