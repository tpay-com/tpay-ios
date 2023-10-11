//
//  Copyright © 2023 Tpay. All rights reserved.
//

struct NewCardDTO: Encodable {
    
    // MARK: - Properties
    
    let payer: PayerDTO
    let callback: String
    let redirect: Redirects
    let card: String
}

extension NewCardDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case payer
        case callback = "callbackUrl"
        case redirect = "redirectUrl"
        case card
    }
}
