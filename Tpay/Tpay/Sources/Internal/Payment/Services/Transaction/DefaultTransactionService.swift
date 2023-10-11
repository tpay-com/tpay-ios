//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultTransactionService: TransactionService {
    
    // MARK: - Properties
    
    private let networkingService: NetworkingService
    private let mapper: TransportationToDomainModelsMapper
    private let encryptor: CardEncryptor
    private let merchant: Merchant
    private let transactionValidator: TransactionValidator
    
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
                  transactionValidator: DefaultTransactionValidator())
    }
    
    init(networkingService: NetworkingService,
         mapper: TransportationToDomainModelsMapper,
         encryptor: CardEncryptor,
         merchant: Merchant,
         transactionValidator: TransactionValidator) {
        self.networkingService = networkingService
        self.mapper = mapper
        self.encryptor = encryptor
        self.merchant = merchant
        self.transactionValidator = transactionValidator
    }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler) {
        let dto = makeNewTransactionDTO(from: transaction, with: blik)
        executeCreateTransactionRequest(with: dto, then: then)
    }

    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        let dto = makeNewTransactionDTO(from: transaction, with: blik)
        executeCreateTransactionRequest(with: dto, then: then)
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
        let dto = makeNewTransactionDTO(from: transaction, with: pbl)
        executeCreateTransactionRequest(with: dto, then: then)
    }
    
    func invokePayment(for transaction: Domain.Transaction, with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler) {
        let dto = makeNewTransactionDTO(from: transaction, with: cardToken)
        executeCreateTransactionRequest(with: dto, then: then)
    }
    
    func invokePayment(for transaction: Domain.Transaction, with applePay: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler) {
        let dto = makeNewTransactionDTO(from: transaction, with: applePay)
        executeCreateTransactionRequest(with: dto, then: then)
    }
    
    func continuePayment(for ongoingTransaction: Domain.OngoingTransaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
        let dto = makePayDTO(from: blik)
        executeContinueTransactionRequest(for: ongoingTransaction.transactionId, with: dto, then: then)
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
    
    private func executeContinueTransactionRequest(for transactionId: String, with dto: PayDTO, then: @escaping OngoingTransactionResultHandler) {
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
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with cardToken: Domain.CardToken) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: cardToken),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with blik: Domain.Blik.Regular) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: blik),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with blik: Domain.Blik.OneClick) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: blik),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with pbl: Domain.PaymentMethod.Bank) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: pbl),
                          payer: makePayerDTO(from: transaction.payer),
                          callbacks: makeCallbacks())
    }
    
    private func makeNewTransactionDTO(from transaction: Domain.Transaction, with applePay: Domain.ApplePayToken) -> NewTransactionDTO {
        NewTransactionDTO(amount: Decimal(transaction.paymentInfo.amount),
                          description: transaction.paymentInfo.title,
                          hiddenDescription: nil,
                          language: makeLanguage(from: Language.current),
                          pay: makePayDTO(from: applePay),
                          payer: makePayerDTO(from: transaction.payer),
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
    
    private func makePayDTO(from card: Domain.Card) throws -> PayDTO {
        PayDTO(groupId: .card, method: .sale, blikPaymentData: nil, cardPaymentData: try makeCardPaymentData(from: card), recursive: nil)
    }
    
    private func makePayDTO(from cardToken: Domain.CardToken) -> PayDTO {
        PayDTO(groupId: .card, method: .sale, blikPaymentData: nil, cardPaymentData: makeCardPaymentData(from: cardToken), recursive: nil)
    }
    
    private func makePayDTO(from blik: Domain.Blik.Regular) -> PayDTO {
        PayDTO(groupId: .blik, method: .sale, blikPaymentData: makeBlikPaymentData(from: blik), cardPaymentData: nil, recursive: nil)
    }
    
    private func makePayDTO(from blik: Domain.Blik.OneClick) -> PayDTO {
        PayDTO(groupId: .blik, method: .sale, blikPaymentData: makeBlikPaymentData(from: blik), cardPaymentData: nil, recursive: nil)
    }
    
    private func makePayDTO(from bank: Domain.PaymentMethod.Bank) -> PayDTO {
        let bankGroupId = BankGroupId(rawValue: bank.id) ?? .unknown
        return PayDTO(groupId: bankGroupId, method: .sale, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
    }
    
    private func makePayDTO(from applePay: Domain.ApplePayToken) -> PayDTO {
        PayDTO(groupId: .applePay, applePayPaymentData: applePay.token)
    }
    
    private func makePayerDTO(from payer: Domain.Payer) -> PayerDTO {
        PayerDTO(email: payer.email, name: payer.name, phone: payer.phone, address: payer.address?.address, postalCode: payer.address?.postalCode, city: payer.address?.city, country: payer.address?.country)
    }
    
    private func makeCardPaymentData(from card: Domain.Card) throws -> PayDTO.CardPaymentData {
        let encrypted = try encryptor.encrypt(card: card).data.base64EncodedString()
        return PayDTO.CardPaymentData(card: encrypted, token: nil, shouldSave: card.shouldTokenize)
    }
    
    private func makeCardPaymentData(from cardToken: Domain.CardToken) -> PayDTO.CardPaymentData {
        PayDTO.CardPaymentData(card: nil, token: cardToken.token, shouldSave: false)
    }
    
    private func makeBlikPaymentData(from blik: Domain.Blik.Regular) -> PayDTO.BlikPaymentData {
        guard let alias = blik.alias else {
            return PayDTO.BlikPaymentData(blikToken: blik.token, aliases: nil)
        }
        return PayDTO.BlikPaymentData(blikToken: blik.token, aliases: makeBlikAlias(from: alias))
    }
    
    private func makeBlikPaymentData(from blik: Domain.Blik.OneClick) -> PayDTO.BlikPaymentData {
        PayDTO.BlikPaymentData(blikToken: nil, aliases: makeBlikAlias(from: blik.alias))
    }
    
    private func makeBlikAlias(from alias: Domain.Blik.Regular.Alias) -> PayDTO.BlikPaymentData.Alias {
        PayDTO.BlikPaymentData.Alias(value: alias.value, type: makeAliasType(for: alias.type), label: alias.label, key: nil)
    }

    private func makeBlikAlias(from alias: Domain.Blik.OneClick.Alias) -> PayDTO.BlikPaymentData.Alias {
        PayDTO.BlikPaymentData.Alias(value: alias.value, type: makeAliasType(for: alias.type), label: nil, key: alias.application?.key)
    }
    
    private func makeCallbacks() -> NewTransactionDTO.Callbacks {
        .init(successUrl: merchant.successCallbackUrl,
              errorURL: merchant.errorCallbackUrl)
    }
    
    private func makeAliasType(for type: Domain.Blik.AliasType) -> PayDTO.BlikPaymentData.Alias.AliasType {
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
