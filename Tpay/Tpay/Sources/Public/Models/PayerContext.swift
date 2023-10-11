//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `PayerContext` struct represents a context that combines information about a payer and their associated automatic payment methods.
///
/// The `PayerContext` can hold information about a payer, such as their name, email, and address, along with their automatic payment methods like registered BLIK alias and tokenized cards.
/// - Note: Both payer and automaticPaymentMethods properties are optional and can be left as nil if not available.
/// - Note: Providing a payer to the context will result in pre-filling the payer's name and email fields in the payment form. However, the user could adjust data to their needs.

public struct PayerContext {
    
    // MARK: - Properties
    
    let payer: Payer?
    let automaticPaymentMethods: AutomaticPaymentMethods?
    
    // MARK: - Initializers
    
    public init(payer: Payer? = nil, automaticPaymentMethods: AutomaticPaymentMethods? = nil) {
        self.payer = payer
        self.automaticPaymentMethods = automaticPaymentMethods
    }
}
