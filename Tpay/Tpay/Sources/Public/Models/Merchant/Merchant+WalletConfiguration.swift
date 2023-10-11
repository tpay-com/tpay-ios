//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Merchant {
    
    /// The `WalletConfiguration` struct encapsulates configuration settings related to digital wallets.
    
    public struct WalletConfiguration: Equatable {
        
        // MARK: - Properties
        
        let applePayConfiguration: ApplePayConfiguration?
        
        // MARK: - Initializer
        
        public init(applePayConfiguration: ApplePayConfiguration? = nil) {
            self.applePayConfiguration = applePayConfiguration
        }
    }
}
