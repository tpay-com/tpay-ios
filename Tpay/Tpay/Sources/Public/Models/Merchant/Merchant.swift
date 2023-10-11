//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// The `Merchant` struct represents a merchant's configuration for interacting with payment services. This configuration includes various settings such as authorization details, card processing settings, environment type, BLIK payment settings, and wallet integration settings.
///
/// The `Merchant` struct is a central component for managing the merchant's interaction with payment-related functionalities.
/// - Note: Not all properties are required; you can provide values for the properties that are relevant to your merchant configuration.

public struct Merchant: Equatable {

    // MARK: - Properties
    
    let authorization: Authorization
    let cardsConfiguration: CardsAPI?
    let environment: Environment
    let blikConfiguration: BlikConfiguration?
    let walletConfiguration: WalletConfiguration?
    
    // MARK: - Initializers

    public init(authorization: Authorization,
                cardsConfiguration: CardsAPI? = nil,
                environment: Environment = .production,
                blikConfiguration: BlikConfiguration? = nil,
                walletConfiguration: WalletConfiguration? = nil) {
        self.authorization = authorization
        self.cardsConfiguration = cardsConfiguration
        self.environment = environment
        self.blikConfiguration = blikConfiguration
        self.walletConfiguration = walletConfiguration
    }
}
