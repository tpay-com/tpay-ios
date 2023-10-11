//
//  Copyright © 2022 Tpay. All rights reserved.
//

/** The `TpayModule` encapsulates various functionalities for configuring and interacting with the Tpay payment module. It provides methods for setting up merchant details, payment methods, SSL certificates, language preferences, and more.
 
 ### Usage Example:
 ```swift
 // Configuring the Tpay module with merchant details and supported languages
 try TpayModule.configure(merchant: myMerchant)
      .configure(merchantDetailsProvider: myMerchantDetailsProvider)
      .configure(supportedLanguages: [.pl, .en])
 
 // Checking the current configuration for validity
 let checkResult = TpayModule.checkConfiguration()
 
 // Registering a transaction status observer
 try TpayModule.register(myObserver, for: myTransactionId)
 ```
 */

public enum TpayModule {
    
    private static var configurationSetter: ConfigurationSetter {
        ModuleContainer.instance.resolver.resolve()
    }
    
    private static var credentialsStore: CredentialsStore {
        ModuleContainer.instance.resolver.resolve()
    }
    
    private static var configuratorValidator: ConfigurationValidator {
        ModuleContainer.instance.resolver.resolve()
    }
    
    private static var networkingConfigurationStore: NetworkingConfigurationStore {
        ModuleContainer.instance.resolver.resolve()
    }
    
    private static let screenlessTransactionService = DefaultScreenlessTransactionService(using: ModuleContainer.instance.resolver)
    
    private static let disposer = Disposer()
    
    // MARK: - API
    
    /// Configures the Tpay module with merchant details.
    /// 
    /// - Parameter merchant: The merchant configuration details.
    /// - Returns: The TpayModule type.
    /// - Throws: Any configuration-related errors that might occur.
    
    @discardableResult
    public static func configure(merchant: Merchant) throws -> TpayModule.Type {
        configurationSetter.set(merchant: merchant)
        credentialsStore.store(credentials: AuthorizationCredentials(user: merchant.authorization.clientId,
                                                                     password: merchant.authorization.clientSecret))
        
        networkingConfigurationStore.store(configuration: NetworkingServiceConfiguration(scheme: merchant.scheme, host: merchant.host))
        return TpayModule.self
    }
    
    /// Configures the Tpay module with supported payment methods.
    ///
    /// - Parameter paymentMethods: An array of supported payment methods.
    /// - Returns: The TpayModule type.
    /// - Throws: MerchantConfigurationError.paymentMethodsEmpty if the array of payment methods is empty.
    
    @discardableResult
    public static func configure(paymentMethods: [PaymentMethod]) throws -> TpayModule.Type {
        guard paymentMethods.isNotEmpty else {
            throw MerchantConfigurationError.paymentMethodsEmpty
        }
        configurationSetter.set(paymentMethods: paymentMethods)
        return TpayModule.self
    }
    
    /// Configures the Tpay module with SSL certificate information.
    ///
    /// - Parameter sslCertificatesProvider: An SSL certificates provider.
    /// - Returns: The TpayModule type.
    
    @discardableResult
    public static func configure(sslCertificatesProvider: SSLCertificatesProvider) -> TpayModule.Type { TpayModule.self }
    
    /// Configures the Tpay module with merchant details provider.
    ///
    /// - Parameter merchantDetailsProvider: A merchant details provider.
    /// - Returns: The TpayModule type.
    
    @discardableResult
    public static func configure(merchantDetailsProvider: MerchantDetailsProvider) -> TpayModule.Type {
        configurationSetter.set(merchantDetailsProvider: merchantDetailsProvider)
        return TpayModule.self
    }
    
    /// Configures the Tpay module with preferred and supported languages.
    ///
    /// - Parameter preferredLanguage: The preferred language.
    /// - Parameter supportedLanguages: An array of supported languages.
    /// - Returns: The TpayModule type.
    /// - Throws: Any configuration-related errors that might occur.
    
    @discardableResult
    public static func configure(preferredLanguage: Language,
                                 supportedLanguages: [Language] = Language.allCases) throws -> TpayModule.Type {
        try checkLanguagesConfiguration(preferredLanguage: preferredLanguage, supportedLanguages: supportedLanguages)
        configurationSetter.set(supportedLanguages: supportedLanguages)
        configurationSetter.set(preferredLanguage: preferredLanguage)
        ModuleContainer.instance.currentLanguage = preferredLanguage
        
        return TpayModule.self
    }
    
    /// Checks the current configuration for validity.
    ///
    /// - Returns: A ConfigurationCheckResult indicating whether the configuration is valid or not.
    
    public static func checkConfiguration() -> ConfigurationCheckResult {
        configuratorValidator.checkProvidedConfiguration()
    }
    
    /// Registers a transaction status observer for a given transaction ID.
    ///
    /// - Parameter transactionStatusObserver: The transaction status observer.
    /// - Parameter transactionWithId: The ID of the transaction to observe.
    /// - Returns: The TpayModule type.
    /// - Throws: Any registration-related errors that might occur.
    
    @discardableResult
    public static func register(_ transactionStatusObserver: TransactionStatusObserver,
                                for transactionWithId: TransactionId) throws -> TpayModule.Type {
        let transaction = Domain.OngoingTransaction(transactionId: transactionWithId, status: .unknown, continueUrl: nil, paymentErrors: nil)
        let transactionObserver = DefaultTransactionObserver(transaction: transaction,
                                                             resolver: ModuleContainer.instance.resolver.resolve())
        transactionObserver.status
            .subscribe(onNext: { status in transactionStatusObserver.update(transactionStatus: self.map(status: status)) })
            .add(to: disposer)
        
        return TpayModule.self
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func payment(with cardPaymentData: PaymentData.Card,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        screenlessTransactionService.invokePayment(with: cardPaymentData, amount: amount, payer: payer, then: then)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func payment(with blikPaymentData: PaymentData.Blik,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        screenlessTransactionService.invokePayment(with: blikPaymentData, amount: amount, payer: payer, then: then)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func payment(with bank: PaymentData.Bank,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionUrl, Error>) -> Void) {
        screenlessTransactionService.invokePayment(with: bank, amount: amount, payer: payer, then: then)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func payment(with digitalWallet: PaymentData.DigitalWallet,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        screenlessTransactionService.invokePayment(with: digitalWallet, amount: amount, payer: payer, then: then)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func getAvailableBanks(completion: @escaping (Result<[PaymentData.Bank], Error>) -> Void) {
        screenlessTransactionService.getAvailableBanks(completion: completion)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func getAvailablePaymentMethods(completion: @escaping (Result<[PaymentMethod], Error>) -> Void) {
        screenlessTransactionService.getAvailablePaymentMethods(completion: completion)
    }
    
    // TODO: Extract to a separate entity, so it does not mix with the main module configuration
    @_documentation(visibility: internal)
    public static func getAvailableDigitalWallets(completion: @escaping (Result<[DigitalWallet], Error>) -> Void) {
        screenlessTransactionService.getAvailableDigitalWallets(completion: completion)
    }
    
    // MARK: - Private
    
    private static func checkLanguagesConfiguration(preferredLanguage: Language, supportedLanguages: [Language]) throws {
        guard supportedLanguages.isNotEmpty else {
            throw ModuleConfigurationError.supportedLanguagesEmpty
        }
        guard supportedLanguages.contains(preferredLanguage) else {
            throw ModuleConfigurationError.preferredLanguageNotInSupportedLanguages
        }
    }
    
    private static func map(status: Domain.OngoingTransaction.Status) -> TransactionStatus {
        switch status {
        case .pending: return .pending
        case .paid: return .paid
        case .correct: return .correct
        case .refund: return .refund
        case .error: return .error
        case .unknown: return .unknown
        }
    }
}
