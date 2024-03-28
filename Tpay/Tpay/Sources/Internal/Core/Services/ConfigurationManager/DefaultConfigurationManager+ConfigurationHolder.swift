//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension DefaultConfigurationManager {
    
    class ConfigurationHolder {
        
        // MARK: - Properties
        
        var merchant: Merchant?
        var callbacksConfiguration: CallbacksConfiguration?
        var merchantDetailsProvider: MerchantDetailsProvider?
        var paymentMethods: [PaymentMethod]?
        
        var preferredLanguage: Language?
        var supportedLanguages: [Language]?
        
        // MARK: - API
        
        func clear() {
            merchant = nil
            callbacksConfiguration = nil
            merchantDetailsProvider = nil
            paymentMethods = nil
            preferredLanguage = nil
            supportedLanguages = nil
        }
    }
}
