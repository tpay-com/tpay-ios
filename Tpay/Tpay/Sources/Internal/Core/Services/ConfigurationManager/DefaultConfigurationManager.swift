//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultConfigurationManager: ConfigurationManager {
    
    // MARK: - Properties
    
    private let configurationHolder = ConfigurationHolder()
    
    // MARK: - API
    
    func clear() {
        configurationHolder.clear()
    }
    
    // MARK: - ConfigurationSetter
        
    func set(merchant: Merchant) {
        configurationHolder.merchant = merchant
    }
    
    func set(callbacksConfiguration: CallbacksConfiguration) {
        configurationHolder.callbacksConfiguration = callbacksConfiguration
    }
    
    func set(merchantDetailsProvider: MerchantDetailsProvider) {
        configurationHolder.merchantDetailsProvider = merchantDetailsProvider
    }
    
    func set(paymentMethods: [PaymentMethod]) {
        configurationHolder.paymentMethods = paymentMethods
    }
    
    func set(preferredLanguage: Language) {
        configurationHolder.preferredLanguage = preferredLanguage
    }

    func set(supportedLanguages: [Language]) {
        configurationHolder.supportedLanguages = supportedLanguages
    }
    
    func set(compatibility: Compatibility, sdkVersionName: String?) {
        configurationHolder.compatibility = compatibility
        configurationHolder.sdkVersionName = sdkVersionName
    }
    
    // MARK: - ConfigurationProvider
    
    var merchant: Merchant? {
        configurationHolder.merchant
    }
    
    var callbacksConfiguration: CallbacksConfiguration {
        configurationHolder.callbacksConfiguration ?? .default
    }
    
    var merchantDetailsProvider: MerchantDetailsProvider? {
        configurationHolder.merchantDetailsProvider
    }
    
    var paymentMethods: [PaymentMethod] {
        configurationHolder.paymentMethods ?? Defaults.paymentMethods
    }
    
    var preferredLanguage: Language {
        configurationHolder.preferredLanguage ?? Defaults.preferredLanguage
    }
    
    var supportedLanguages: [Language] {
        configurationHolder.supportedLanguages ?? Defaults.supportedLanguages
    }

    var compatibility: Compatibility {
        configurationHolder.compatibility ?? Defaults.compatibility
    }

    var sdkVersionName: String? {
        configurationHolder.sdkVersionName
    }
}

extension DefaultConfigurationManager {

    enum Defaults {

        static let paymentMethods = PaymentMethod.allCases
        static let preferredLanguage = Language.pl
        static let supportedLanguages = Language.allCases
        static let compatibility = Compatibility.ios

    }
}
