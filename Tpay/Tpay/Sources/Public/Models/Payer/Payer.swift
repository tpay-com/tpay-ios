//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `Payer` struct represents information about a payer, such as a customer or an account holder. This information includes the payer's name, email, phone number, and address.
///
/// - Note: The phone and address properties are optional and can be left as nil if not available.

public struct Payer {
    
    // MARK: - Properties
    
    let name: String
    let email: String
    let phone: String?
    let address: Address?
    
    // MARK: - Initializers
    
    public init(name: String,
                email: String,
                phone: String? = nil,
                address: Address? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
    }
}
