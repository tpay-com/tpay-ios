//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultConfigurationValidator: ConfigurationValidator {
    
    // MARK: - Properties
    
    private let configurationProvider: ConfigurationProvider
    
    private lazy var applePayConfigurationValidator = ApplePayConfigurationValidator(configurationProvider.merchant?.walletConfiguration?.applePayConfiguration)
    private lazy var cardConfigurationValidator = CardConfigurationValidator(configurationProvider.merchant?.cardsConfiguration)
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(configurationProvider: resolver.resolve())
    }
    
    init(configurationProvider: ConfigurationProvider) {
        self.configurationProvider = configurationProvider
    }
    
    // MARK: - API
    
    func checkProvidedConfiguration() -> ConfigurationCheckResult {
        var configurationErrors: [MerchantConfigurationError] = []
        
        if configurationProvider.merchantDetailsProvider == nil {
            configurationErrors.append(.merchantDetailsNotProvided)
        }
        
        guard configurationProvider.merchant != nil else {
            configurationErrors.append(.merchantNotProvided)
            return configurationCheckResult(from: configurationErrors)
        }
        
        let paymentConfigurationErrors = checkPaymentConfigurationErrors()
        configurationErrors.append(contentsOf: paymentConfigurationErrors)
        
        return configurationCheckResult(from: configurationErrors)
    }
    
    // MARK: - Private
    
    private func checkPaymentConfigurationErrors() -> [MerchantConfigurationError] {
        let paymentMethods = configurationProvider.paymentMethods
        var configurationErrors: [MerchantConfigurationError] = []
        
        for paymentMethod in paymentMethods {
            switch paymentMethod {
            case .card:
                guard case ConfigurationCheckResult.invalid(let error) = cardConfigurationValidator.checkProvidedConfiguration() else { continue }
                configurationErrors.append(error)
            case .digitalWallet(.applePay):
                guard case ConfigurationCheckResult.invalid(let error) = applePayConfigurationValidator.checkProvidedConfiguration() else { continue }
                configurationErrors.append(error)
            default: break
            }
        }
        
        return configurationErrors
    }
    
    private func configurationCheckResult(from errors: [MerchantConfigurationError]) -> ConfigurationCheckResult {
        guard let error = errors.first else {
            return .valid
        }
        return .invalid(errors.count == 1 ? error : .multiple(errors))
    }
}
