//
//  Copyright © 2022 Tpay. All rights reserved.
//

public struct Address {
    
    // MARK: - Properties
    
    let address: String?
    let city: String?
    let country: String?
    let postalCode: String?
    
    // MARK: - Initializers
    
    public init(address: String?,
                city: String?,
                country: String?,
                postalCode: String?) {
        self.address = address
        self.city = city
        self.country = country
        self.postalCode = postalCode
    }
}
