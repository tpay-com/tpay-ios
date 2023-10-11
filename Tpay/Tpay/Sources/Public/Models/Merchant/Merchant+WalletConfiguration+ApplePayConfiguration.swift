//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Merchant.WalletConfiguration {
    
    /// The `ApplePayConfiguration` struct encapsulates essential configuration settings for integrating Apple Pay.
    ///
    /// - Note: The countryCode property defines the country for Apple Pay integration, with the default set to .pl.
    ///
    /// To obtain the merchantIdentifier, follow these steps:
    /// 1. Log in to your Apple Developer account.
    /// 2. Navigate to the "Certificates, Identifiers & Profiles" section.
    /// 3. Under "Identifiers," select "Merchant IDs."
    /// 4. Click the "+" button to create a new Merchant ID.
    /// 5. Fill in the required information and associate it with your app's Bundle ID.
    /// 6. Once created, the merchant identifier can be found in the list of Merchant IDs.
    /// 7. For more details, please follow [Apple Pay documentation ](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay).

    public struct ApplePayConfiguration: Equatable {
        
        // MARK: - Properties
        
        let merchantIdentifier: String
        let countryCode: CountryCode
        
        // MARK: - Initializers
        
        public init(merchantIdentifier: String, countryCode: CountryCode = .pl) {
            self.merchantIdentifier = merchantIdentifier
            self.countryCode = countryCode
        }
    }
}

extension Merchant.WalletConfiguration.ApplePayConfiguration {
    
    public enum CountryCode: String {
        
        // MARK: - Cases
        
        case pl = "PL"
    }
}
