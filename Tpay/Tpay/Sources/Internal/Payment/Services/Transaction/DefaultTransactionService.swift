//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultTransactionService: TransactionService {
    
    // MARK: - Properties
    
    private let networkingService: NetworkingService
    private let mapper: TransportationToDomainModelsMapper
    private let encryptor: CardEncryptor
    private let merchant: Merchant
    private let callbacksConfiguration: CallbacksConfiguration
    private let transactionValidator: TransactionValidator
    private let paymentMethodsService: PaymentMethodsService
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchant = configurationProvider.merchant else {
            preconditionFailure("Merchant is not configured")
        }
        self.init(networkingService: resolver.resolve(),
                  mapper: DefaultTransportationToDomainModelsMapper(),
                  encryptor: DefaultCardEncryptor(using: resolver),
                  merchant: merchant, 
                  callbacksConfiguration: configurationProvider.callbacksConfiguration,
                  transactionValidator: DefaultTransactionValidator(),
                  paymentMethodsService: resolver.resolve())
    }
    
    init(networkingService: NetworkingService,
         mapper: TransportationToDomainModelsMapper,
         encryptor: CardEncryptor,
         merchant: Merchant,
         callbacksConfiguration: CallbacksConfiguration,
         transactionValidator: TransactionValidator,
         paymentMethodsService: PaymentMethodsService) {
        self.networkingService = networkingService
        self.mapper = mapper
        self.encryptor = encryptor
        self.merchant = merchant
        self.callbacksConfiguration = callbacksConfiguration
        self.transactionValidator = transactionValidator
        self.paymentMethodsService = paymentMethodsService
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: blik)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }

    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: blik)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func invokePayment(for transaction: Domain.Transaction, with card: Domain.Card, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: card)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func invokePayment(for transaction: Domain.Transaction, with pbl: Domain.PaymentMethod.Bank, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: pbl)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func invokePayment(for transaction: Domain.Transaction, with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: cardToken)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func invokePayment(for transaction: Domain.Transaction, with applePay: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: applePay)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func invokePayment(for transaction: Domain.Transaction, with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler) {
        let dto = makeNewTransactionDTO(from: transaction, with: installmentPayment)
        executeCreateTransactionRequest(with: dto, then: then)
    }
    
    func invokePayment(for transaction: Domain.Transaction, with payPoPayer: Domain.Payer, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makeNewTransactionDTO(from: transaction, with: payPoPayer)
            executeCreateTransactionRequest(with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    func getPaymentStatus(for ongoingTransaction: Domain.OngoingTransaction, then: @escaping OngoingTransactionResultHandler) {
        executeGetSpecifiedTransactionRequest(for: ongoingTransaction.transactionId, then: then)
    }
    
    func continuePayment(for ongoingTransaction: Domain.OngoingTransaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        do {
            let dto = try makePayDTO(from: blik)
            executeContinueTransactionRequest(for: ongoingTransaction.transactionId, with: dto, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    // MARK: - Private
    
    private func executeCreateTransactionRequest(with dto: NewTransactionDTO, then: @escaping OngoingTransactionResultHandler) {
        let request = TransactionsController.CreateTransaction(dto: dto)
        networkingService.execute(request: request)
            .onSuccess { [weak self] transactionDto in
                guard let self = self else { return }
                let ongoingTransaction = self.mapper.makeOngoingTransaction(from: transactionDto)
                self.validate(transaction: ongoingTransaction, then: then)
            }
            .onError { error in then(.failure(error)) }
    }
    
    private func executeGetSpecifiedTransactionRequest(for transactionId: String, then: @escaping OngoingTransactionResultHandler) {
        let request = TransactionsController.SpecifiedTransaction(with: transactionId)
        networkingService.execute(request: request)
            .onSuccess { [weak self] transactionDto in
                guard let self = self else { return }
                let ongoingTransaction = self.mapper.makeOngoingTransaction(from: transactionDto)
                self.validate(transaction: ongoingTransaction, then: then)
            }
            .onError { error in then(.failure(error)) }
    }
    
    private func executeContinueTransactionRequest(for transactionId: String, with dto: PayWithInstantRedirectionDTO, then: @escaping OngoingTransactionResultHandler) {
        let request = TransactionsController.PayForSpecifiedTransaction(transactionId: transactionId, dto: dto)
        networkingService.execute(request: request)
            .onSuccess { [weak self] transactionDto in
                guard let self = self else { return }
                let ongoingTransaction = self.mapper.makeOngoingTransaction(from: transactionDto)
                self.validate(transaction: ongoingTransaction, then: then)
            }
            .onError { error in then(.failure(error)) }
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with card: Domain.Card) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: card),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with cardToken: Domain.CardToken) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: cardToken),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with blik: Domain.Blik.Regular) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: blik),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with blik: Domain.Blik.OneClick) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: blik),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with pbl: Domain.PaymentMethod.Bank) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: pbl),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with applePay: Domain.ApplePayToken) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTO(from: applePay),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with installmentPayments: Domain.PaymentMethod.InstallmentPayment) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: installmentPayments),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with payPoPayer: Domain.Payer) throws -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: try makePayDTOForPayPo(),
                          payer: makePayerDTO(from: payPoPayer),
                          callbacks: makeCallbacks())
    }
    
    private func makeLanguage(from language: Language) -> NewTransactionDTO.Language {
        switch language {
        case .pl:
            return .pl
        case .en:
            return .en
        }
    }
    
    private func makePayDTO(from card: Domain.Card) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .card),
                                     method: .sale,
                                     blikPaymentData: nil,
                                     cardPaymentData: try makeCardPaymentData(from: card),
                                     recursive: nil)
    }
    
    private func makePayDTO(from cardToken: Domain.CardToken) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .card),
                                     method: .sale,
                                     blikPaymentData: nil,
                                     cardPaymentData: makeCardPaymentData(from: cardToken),
                                     recursive: nil)
    }
    
    private func makePayDTO(from blik: Domain.Blik.Regular) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .blik),
                                     method: .sale,
                                     blikPaymentData: makeBlikPaymentData(from: blik),
                                     cardPaymentData: nil,
                                     recursive: nil)
    }
    
    private func makePayDTO(from blik: Domain.Blik.OneClick) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .blik),
                                     method: .sale,
                                     blikPaymentData: makeBlikPaymentData(from: blik),
                                     cardPaymentData: nil,
                                     recursive: nil)
    }
    
    private func makePayDTO(from bank: Domain.PaymentMethod.Bank) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: bank.id,
                                     method: .sale,
                                     blikPaymentData: nil,
                                     cardPaymentData: nil,
                                     recursive: nil)
    }
    
    private func makePayDTO(from applePay: Domain.ApplePayToken) throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .applePay),
                                     applePayPaymentData: applePay.token)
    }
    
    private func makePayDTO(from installmentPayment: Domain.PaymentMethod.InstallmentPayment) -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: installmentPayment.id, method: .sale, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
    }
    
    private func makePayDTOForPayPo() throws -> PayWithInstantRedirectionDTO {
        PayWithInstantRedirectionDTO(channelId: try paymentMethodsService.channelId(for: .payPo),
                                     method: .sale,
                                     blikPaymentData: nil,
                                     cardPaymentData: nil,
                                     recursive: nil)
    }
    
    private func makePayerDTO(from payer: Domain.Payer) -> PayerDTO {
        PayerDTO(email: payer.email, name: payer.name, phone: payer.phone, address: payer.address?.address, postalCode: payer.address?.postalCode, city: payer.address?.city, country: payer.address?.country)
    }
    
    private func makeCardPaymentData(from card: Domain.Card) throws -> PayWithInstantRedirectionDTO.CardPaymentData {
        let encrypted = try encryptor.encrypt(card: card).data.base64EncodedString()
        return PayWithInstantRedirectionDTO.CardPaymentData(card: encrypted, token: nil, shouldSave: card.shouldTokenize)
    }
    
    private func makeCardPaymentData(from cardToken: Domain.CardToken) -> PayWithInstantRedirectionDTO.CardPaymentData {
        PayWithInstantRedirectionDTO.CardPaymentData(card: nil, token: cardToken.token, shouldSave: false)
    }
    
    private func makeBlikPaymentData(from blik: Domain.Blik.Regular) -> PayWithInstantRedirectionDTO.BlikPaymentData {
        guard let alias = blik.alias else {
            return PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: blik.token, aliases: nil)
        }
        return PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: blik.token, aliases: makeBlikAlias(from: alias))
    }
    
    private func makeBlikPaymentData(from blik: Domain.Blik.OneClick) -> PayWithInstantRedirectionDTO.BlikPaymentData {
        PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: nil, aliases: makeBlikAlias(from: blik.alias))
    }
    
    private func makeBlikAlias(from alias: Domain.Blik.Regular.Alias) -> PayWithInstantRedirectionDTO.BlikPaymentData.Alias {
        PayWithInstantRedirectionDTO.BlikPaymentData.Alias(value: alias.value, type: makeAliasType(for: alias.type), label: alias.label, key: nil)
    }

    private func makeBlikAlias(from alias: Domain.Blik.OneClick.Alias) -> PayWithInstantRedirectionDTO.BlikPaymentData.Alias {
        PayWithInstantRedirectionDTO.BlikPaymentData.Alias(value: alias.value, type: makeAliasType(for: alias.type), label: nil, key: alias.application?.key)
    }
    
    private func makeCallbacks() -> NewTransactionDTO.Callbacks {
        .init(successUrl: callbacksConfiguration.successRedirectUrl,
              errorUrl: callbacksConfiguration.errorRedirectUrl,
              notificationUrl: callbacksConfiguration.notificationsUrl)
    }
    
    private func makeAliasType(for type: Domain.Blik.AliasType) -> PayWithInstantRedirectionDTO.BlikPaymentData.Alias.AliasType {
        switch type {
        case .payId:
            return .payId
        case .uId:
            return .uId
        }
    }
    
    private func validate(transaction: Domain.OngoingTransaction, then: @escaping OngoingTransactionResultHandler) {
        do {
            try transactionValidator.validate(transaction: transaction)
            then(.success(transaction))
        } catch let error as Domain.OngoingTransaction.PaymentError {
            handleCaughtPaymentError(error, for: transaction, then: then)
        } catch {
            then(.failure(error))
        }
    }
    
    private func handleCaughtPaymentError(_ error: Domain.OngoingTransaction.PaymentError,
                                          for transaction: Domain.OngoingTransaction,
                                          then: @escaping OngoingTransactionResultHandler) {
        guard case .ambiguousBlikAlias(alternatives: _) = error else {
            then(.failure(error))
            return
        }
        then(.success(transaction))
    }
}
