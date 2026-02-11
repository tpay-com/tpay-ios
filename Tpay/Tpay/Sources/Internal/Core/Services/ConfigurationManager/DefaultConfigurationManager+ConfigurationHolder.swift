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

        var compatibility: Compatibility?
        var sdkVersionName: String?

        // MARK: - API

        func clear() {
            merchant = nil
            callbacksConfiguration = nil
            merchantDetailsProvider = nil
            paymentMethods = nil
            preferredLanguage = nil
            supportedLanguages = nil
            compatibility = nil
            sdkVersionName = nil
        }
    }
}
