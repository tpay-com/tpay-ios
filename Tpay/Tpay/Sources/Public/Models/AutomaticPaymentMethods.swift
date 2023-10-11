//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `AutomaticPaymentMethods` struct represents a collection of automatic payment methods associated with a concrete payer.
///
/// Automatic payment methods include registered BLIK alias and tokenized cards, which can be used for seamless transactions and payments.

public struct AutomaticPaymentMethods {
    
    // MARK: - Properties
    
    let registeredBlikAlias: RegisteredBlikAlias?
    let tokenizedCards: [CardToken]?
    
    // MARK: - Initializers
    
    public init(registeredBlikAlias: RegisteredBlikAlias? = nil, tokenizedCards: [CardToken]? = nil) {
        self.registeredBlikAlias = registeredBlikAlias
        self.tokenizedCards = tokenizedCards
    }
}
