//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Security

extension Merchant {
    
    /// The `CardsAPI` struct encapsulates the configuration for interacting with card-related APIs, including the public key required for encrypting sensitive credit card data during communication.
    ///
    /// You must acquire dedicated Public RSA key from the [Merchant panel (card-payments/api)](https://panel.tpay.com/card-payments/api).

    public struct CardsAPI: Equatable {
        
        // MARK: - Properties

        let publicKey: SecKey
        
        // MARK: - Initializers
        
        /// Initializes a CardsAPI struct with RSA public key.
        ///
        ///  - parameter publicKey: A base64-encoded RSA public key acquired from the Merchant panel.
        ///  - throws: `ConfigurationError.invalidRSAPublicKey` in case of providing an invalid key.

        public init(publicKey base64EncodedRSAPublicKey: String) throws {
            guard let publicKey = SecKey.decodePublicKey(from: base64EncodedRSAPublicKey) else {
                throw ConfigurationError.invalidRSAPublicKey
            }
            self.init(publicKey: publicKey)
        }
        
        init(publicKey: SecKey) {
            self.publicKey = publicKey
        }
    }
}
