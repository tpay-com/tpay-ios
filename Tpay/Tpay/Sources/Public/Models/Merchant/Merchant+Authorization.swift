//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Merchant {
    
    /// The `Authorization` struct represents the authorization details required for secure interactions with payment services.
    ///
    /// These authorization details consist of a client ID and a client secret, which are used to authenticate and establish a secure connection to payment APIs.
    /// You must acquire dedicated API keys from the [Merchant panel (integration/api)](https://panel.tpay.com/integration/api).
    /// - Note: Safeguard the confidentiality of the client ID and client secret. Do not expose or share them publicly.
    
    public struct Authorization: Equatable {
        
        // MARK: - Properties

        let clientId: String
        let clientSecret: String
        
        // MARK: - Initializers

        public init(clientId: String, clientSecret: String) {
            self.clientId = clientId
            self.clientSecret = clientSecret
        }
    }
}
