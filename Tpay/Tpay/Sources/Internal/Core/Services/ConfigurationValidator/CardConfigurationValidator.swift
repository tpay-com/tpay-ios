//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class CardConfigurationValidator: ConfigurationValidator {
    
    // MARK: - Properties
    
    private let configuration: Merchant.CardsAPI?
    
    // MARK: - Initializers
    
    init(_ configuration: Merchant.CardsAPI?) {
        self.configuration = configuration
    }
    
    // MARK: - API
    
    func checkProvidedConfiguration() -> ConfigurationCheckResult {
        configuration != nil ? .valid : .invalid(.cardsConfigurationNotProvided)
    }
}
