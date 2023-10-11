//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `CardToken` struct represents a tokenized card. It consists of a token's body, a card tail and a card brand.
///
/// All the necessary data is sent after succesfull tokenization via tpay.com system notifications. For more information, you should follow `Notifications And Receiving Data After Transaction` section under [OpenAPI documentation](https://openapi.tpay.com).

public struct CardToken {
    
    // MARK: - Properties
    
    let token: String
    let cardTail: String
    let brand: Brand
    
    // MARK: - Initializers
    
    /// Initializes a card token.
    /// - Throws: A `CardToken.ConfigurationError.invalidCardTail` error if a card tail is not a 4-digit number.
    
    public init(token: String, cardTail: String, brand: Brand) throws {
        guard cardTail.count == 4, Int(cardTail) != nil else {
            throw CardToken.ConfigurationError.invalidCardTail
        }
        
        self.token = token
        self.cardTail = cardTail
        self.brand = brand
    }
}
