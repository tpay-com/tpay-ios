//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultPaymentMethodsService: PaymentMethodsService {
    
    // MARK: - Properties
    
    var paymentMethods: [Domain.PaymentMethod] { paymentDataStore.paymentMethods }
    
    private let configurationManager: ConfigurationManager
    private let paymentDataStore: PaymentDataStore
    private let mapper: APIToDomainModelsMapper
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(configurationManager: resolver.resolve(),
                  paymentDataStore: resolver.resolve(),
                  mapper: DefaultAPIToDomainModelsMapper())
    }
    
    init(configurationManager: ConfigurationManager,
         paymentDataStore: PaymentDataStore,
         mapper: APIToDomainModelsMapper) {
        self.configurationManager = configurationManager
        self.paymentDataStore = paymentDataStore
        self.mapper = mapper
    }
    
    // MARK: - API
    
    func store(availablePaymentMethods: [Domain.PaymentMethod], completion: @escaping Completion) {
        let merchantMethods = paymentMethodsWithValidConfiguration().compactMap { [weak self] merchantMethod in
            self?.mapper.makePaymentMethod(from: merchantMethod)
        }
        let availableMerchantMethods = compare(merchantMethods: merchantMethods, with: availablePaymentMethods)
        paymentDataStore.set(paymentMethods: availableMerchantMethods)
        completion(.success(()))
    }
    
    // MARK: - Private
    
    private func compare(merchantMethods: [Domain.PaymentMethod], with availablePaymentMethods: [Domain.PaymentMethod]) -> [Domain.PaymentMethod] {
        var result: [Domain.PaymentMethod] = []
        
        for method in merchantMethods {
            switch method {
            case .pbl:
                let allBanks = availablePaymentMethods.allBankMethods()
                allBanks.forEach { bankMethod in result.append(bankMethod, if: !result.contains(bankMethod)) }
            case .digitalWallet(let wallet):
                let allWallets = availablePaymentMethods.allWallets()
                if let availableWallet = allWallets.first(where: { $0.kind == wallet.kind }) {
                    result.append(.digitalWallet(availableWallet))
                }
            default:
                guard availablePaymentMethods.contains(method) else { continue }
                result.append(method, if: !result.contains(method))
            }
        }
        return result
    }
    
    private func paymentMethodsWithValidConfiguration() -> [PaymentMethod] {
        guard configurationManager.merchant != nil else {
            Logger.info("PaymentMethods is empty beacause merchant is nil")
            return []
        }

        return configurationManager.paymentMethods.filter { [weak self] paymentMethod in
            switch paymentMethod {
            case .card:
                let cardValidator = CardConfigurationValidator(self?.configurationManager.merchant?.cardsConfiguration)
                guard cardValidator.checkProvidedConfiguration() == .valid else {
                    Logger.info("Card configuration is invalid and this payment method will not be available")
                    return false
                }
                return true
            case .digitalWallet(.applePay):
                let applePayValidator = ApplePayConfigurationValidator(self?.configurationManager.merchant?.walletConfiguration?.applePayConfiguration)
                guard applePayValidator.checkProvidedConfiguration() == .valid else {
                    Logger.info("Apple Pay configuration is invalid and this digital wallet will not be available")
                    return false
                }
                return true
            default: return true
            }
        }
    }
    
}
