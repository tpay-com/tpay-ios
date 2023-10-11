//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class ApplePayConfigurationValidator: ConfigurationValidator {
    
    // MARK: - Properties
    
    private let configuration: Merchant.WalletConfiguration.ApplePayConfiguration?
    
    // MARK: - Initializers
    
    init(_ configuration: Merchant.WalletConfiguration.ApplePayConfiguration?) {
        self.configuration = configuration
    }
    
    // MARK: - API
    
    func checkProvidedConfiguration() -> ConfigurationCheckResult {
        configuration != nil ? .valid : .invalid(.applePayConfigurationNotProvided)
    }
}
