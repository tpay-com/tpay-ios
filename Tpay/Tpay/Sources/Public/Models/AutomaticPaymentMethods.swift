//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `AutomaticPaymentMethods` struct represents a collection of automatic payment methods associated with a concrete payer.
///
/// Automatic payment methods include registered BLIK alias, not-yet-registered BLIK alias, and tokenized cards, which can be used for seamless transactions and payments.
/// - Parameter registeredBlikAlias: An already registered BLIK alias, used for BLIK OneClick payments.
/// - Parameter notRegisteredBlikAlias: A BLIK alias to be registered during a standard BLIK payment. When provided, a checkbox allowing the payer to save the alias will be displayed.
/// - Parameter tokenizedCards: Tokenized cards created after a successful credit card payment.

public struct AutomaticPaymentMethods {

    // MARK: - Properties

    let registeredBlikAlias: RegisteredBlikAlias?
    let notRegisteredBlikAlias: NotRegisteredBlikAlias?
    let tokenizedCards: [CardToken]?

    // MARK: - Initializers

    public init(registeredBlikAlias: RegisteredBlikAlias? = nil,
                notRegisteredBlikAlias: NotRegisteredBlikAlias? = nil,
                tokenizedCards: [CardToken]? = nil) {
        self.registeredBlikAlias = registeredBlikAlias
        self.notRegisteredBlikAlias = notRegisteredBlikAlias
        self.tokenizedCards = tokenizedCards
    }
}
