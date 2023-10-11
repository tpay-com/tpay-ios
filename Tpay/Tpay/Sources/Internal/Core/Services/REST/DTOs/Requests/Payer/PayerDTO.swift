//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct PayerDTO: Encodable {
    
    // MARK: - Properties
    
    let email: String
    let name: String
    
    let phone: String?
    let address: String?
    let postalCode: String?
    let city: String?
    let country: String?
}

extension PayerDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case email
        case name
        
        case phone
        case address
        case postalCode = "code"
        case city
        case country
    }
}
