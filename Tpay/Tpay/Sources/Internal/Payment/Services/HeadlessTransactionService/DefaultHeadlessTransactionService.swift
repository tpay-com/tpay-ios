//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultHeadlessTransactionService: HeadlessTransactionService {
    
    // MARK: - Properties
    
    private let authenticationService: AuthenticationService
    private let paymentDataService: PaymentDataService
    private let paymentMethodsService: PaymentMethodsService
    private var transactionService: TransactionService { transactionServiceFactory() }
    private let apiToDomainModelsMapper: APIToDomainModelsMapper
    private let domainToAPIModelsMapper: DomainToAPIModelsMapper
    private let transactionServiceFactory: () -> TransactionService
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        self.init(authenticationService: DefaultAuthenticationService(resolver: resolver),
                  paymentDataService: DefaultPaymentDataService(resolver: resolver),
                  paymentMethodsService: DefaultPaymentMethodsService(resolver: resolver),
                  transactionServiceFactory: { DefaultTransactionService(using: resolver) },
                  apiToDomainModelsMapper: DefaultAPIToDomainModelsMapper(),
                  domainToAPIModelsMapper: DefaultDomainToAPIModelsMapper())
    }
    
    init(authenticationService: AuthenticationService,
         paymentDataService: PaymentDataService,
         paymentMethodsService: PaymentMethodsService,
         transactionServiceFactory: @escaping() -> TransactionService,
         apiToDomainModelsMapper: APIToDomainModelsMapper,
         domainToAPIModelsMapper: DomainToAPIModelsMapper) {
        self.authenticationService = authenticationService
        self.paymentDataService = paymentDataService
        self.paymentMethodsService = paymentMethodsService
        self.transactionServiceFactory = transactionServiceFactory
        self.apiToDomainModelsMapper = apiToDomainModelsMapper
        self.domainToAPIModelsMapper = domainToAPIModelsMapper
    }
    
    // MARK: - API
    
    func getAvailablePaymentChannels(completion: @escaping (Result<[Headless.Models.PaymentChannel], Error>) -> Void) {
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .append(paymentDataService.fetchChannels)
            .invoke { [weak self, domainToAPIModelsMapper] result in
                completion(result.map { self?.paymentMethodsService.paymentChannels.tryMap(using: domainToAPIModelsMapper) ?? [] })
            }
    }
    
    func invokePayment(for transaction: Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with card: Headless.Models.Card,
                       completion: @escaping (Result<PaymentResult, Error>) -> Void) throws {
        let card = apiToDomainModelsMapper.makeDomainCard(from: card)
        try invokePayment(for: transaction, using: CardPaymentInvoker(transactionService: transactionService, card: card), completion: completion)
    }
    
    func invokePayment(for transaction: Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with cardToken: Headless.Models.CardToken,
                       completion: @escaping (Result<PaymentResult, Error>) -> Void) throws {
        let cardToken = apiToDomainModelsMapper.makeCardToken(from: cardToken)
        try invokePayment(for: transaction, using: CardTokenPaymentInvoker(transactionService: transactionService, cardToken: cardToken), completion: completion)
    }
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with blik: Headless.Models.Blik.Regular,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        let blik = apiToDomainModelsMapper.makeDomainBlikRegular(from: blik)
        try invokePayment(for: transaction, using: BlikRegularPaymentInvoker(transactionService: transactionService, blik: blik), completion: completion)
    }
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with blik: Headless.Models.Blik.OneClick,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        let blik = try apiToDomainModelsMapper.makeDomainBlikOneClick(from: blik)
        try invokePayment(for: transaction, using: BlikOneClickPaymentInvoker(transactionService: transactionService, blik: blik), completion: completion)
    }
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with bank: Headless.Models.Bank,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        try invokePayment(for: transaction, using: BankPaymentInvoker(transactionService: transactionService, paymentChannel: paymentChannel), completion: completion)
    }
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with applePay: Headless.Models.ApplePay,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        let applePayToken = apiToDomainModelsMapper.makeDomainApplePayToken(from: applePay)
        try invokePayment(for: transaction, using: ApplePayPaymentInvoker(transactionService: transactionService, applePayToken: applePayToken), completion: completion)
    }
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with installment: Headless.Models.InstallmentPayment,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        try invokePayment(for: transaction, using: InstallmentPaymentInvoker(transactionService: transactionService, paymentChannel: paymentChannel), completion: completion)
    }
    
    func invokePayPoPayment(for transaction: any Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       completion: @escaping (Result<any Headless.Models.PaymentResult, any Error>) -> Void) throws {
        try invokePayment(for: transaction, using: PayPoPaymentInvoker(transactionService: transactionService), completion: completion)
    }
    
    func getPaymentStatus(for ongoingTransaction: Headless.Models.OngoingTransaction, completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) {
        let ongoingTransaction = apiToDomainModelsMapper.makeDomainOngoingTransaction(from: ongoingTransaction)
        var updatedTransaction: Domain.OngoingTransaction?
        
        func updatePaymentStatus(_ then: @escaping Completion) {
            transactionService.getPaymentStatus(for: ongoingTransaction) { result in
                updatedTransaction = try? result.get()
                then(result.map { _ in () })
            }
        }
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .append(updatePaymentStatus)
            .invoke { [domainToAPIModelsMapper] result in
                result.match(onSuccess: {
                    guard let updatedTransaction else {
                        completion(.failure(Headless.Models.PaymentError.missingOngoingTransaction))
                        return
                    }
                    completion(.success(domainToAPIModelsMapper.makeHeadlessModelsPaymentResult(from: updatedTransaction)))
                }, onFailure: { completion(.failure($0)) })
            }
    }
    
    func continuePayment(for ongoingTransaction: Headless.Models.OngoingTransaction,
                         with blikAlias: Headless.Models.Blik.AmbiguousBlikAlias,
                         completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws {
        let ongoingTransaction = apiToDomainModelsMapper.makeDomainOngoingTransaction(from: ongoingTransaction)
        let blik = try apiToDomainModelsMapper.makeDomainBlikOneClickWithApplication(from: blikAlias)
        var updatedTransaction: Domain.OngoingTransaction?
        
        func continueBlikPayment(_ then: @escaping Completion) {
            transactionService.continuePayment(for: ongoingTransaction, with: blik) { result in
                updatedTransaction = try? result.get()
                then(result.map { _ in () })
            }
        }
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .append(continueBlikPayment)
            .invoke { [domainToAPIModelsMapper] result in
                result.match(onSuccess: {
                    guard let updatedTransaction else {
                        completion(.failure(Headless.Models.PaymentError.missingOngoingTransaction))
                        return
                    }
                    completion(.success(domainToAPIModelsMapper.makeHeadlessModelsPaymentResult(from: updatedTransaction)))
                }, onFailure: { completion(.failure($0)) })
            }
    }
    
    // MARK: - Private
    
    private func invokePayment(for transaction: Transaction, using invoker: PaymentInvoker, completion: @escaping (Result<PaymentResult, Error>) -> Void) throws {
        let transaction = try apiToDomainModelsMapper.makeDomainTransaction(from: transaction)
        var ongoingTransaction: Domain.OngoingTransaction?
        
        func invokePayment(_ then: @escaping Completion) {
            invoker.invokePayment(for: transaction) { result in
                ongoingTransaction = try? result.get()
                then(result.map { _ in () })
            }
        }
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .append(invokePayment)
            .invoke { [domainToAPIModelsMapper] result in
                result.match(onSuccess: {
                    guard let ongoingTransaction else {
                        completion(.failure(Headless.Models.PaymentError.missingOngoingTransaction))
                        return
                    }
                    completion(.success(domainToAPIModelsMapper.makeHeadlessModelsPaymentResult(from: ongoingTransaction)))
                }, onFailure: { completion(.failure($0)) })
            }
    }
}

// MARK: - Invokers

private protocol PaymentInvoker {
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler)
}

private final class CardPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let card: Domain.Card
    
    init(transactionService: TransactionService, card: Domain.Card) {
        self.transactionService = transactionService
        self.card = card
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: card, then: then)
    }
}

private final class CardTokenPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let cardToken: Domain.CardToken
    
    init(transactionService: TransactionService, cardToken: Domain.CardToken) {
        self.transactionService = transactionService
        self.cardToken = cardToken
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: cardToken, ignoreErrorsWhenContinueUrlExists: false, then: then)
    }
}

private final class BlikRegularPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let blik: Domain.Blik.Regular
    
    init(transactionService: TransactionService, blik: Domain.Blik.Regular) {
        self.transactionService = transactionService
        self.blik = blik
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: blik, then: then)
    }
}

private final class BlikOneClickPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let blik: Domain.Blik.OneClick
    
    init(transactionService: TransactionService, blik: Domain.Blik.OneClick) {
        self.transactionService = transactionService
        self.blik = blik
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: blik, then: then)
    }
}

private final class BankPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let bank: Domain.PaymentMethod.Bank
    
    init(transactionService: TransactionService, paymentChannel: Headless.Models.PaymentChannel) {
        self.transactionService = transactionService
        self.bank = Domain.PaymentMethod.Bank(id: paymentChannel.id, name: .empty, imageUrl: nil)
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: bank, then: then)
    }
}

private final class ApplePayPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let applePayToken: Domain.ApplePayToken
    
    init(transactionService: TransactionService, applePayToken: Domain.ApplePayToken) {
        self.transactionService = transactionService
        self.applePayToken = applePayToken
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: applePayToken, then: then)
    }
}

private final class InstallmentPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    private let installmentPayment: Domain.PaymentMethod.InstallmentPayment
    
    init(transactionService: TransactionService, paymentChannel: Headless.Models.PaymentChannel) {
        self.transactionService = transactionService
        self.installmentPayment = Domain.PaymentMethod.InstallmentPayment(id: paymentChannel.id, kind: .unknown, name: .empty, imageUrl: nil)
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: installmentPayment, then: then)
    }
}

private final class PayPoPaymentInvoker: PaymentInvoker {
    private let transactionService: TransactionService
    
    init(transactionService: TransactionService) {
        self.transactionService = transactionService
    }
    
    func invokePayment(for transaction: Domain.Transaction, then: @escaping OngoingTransactionResultHandler) {
        transactionService.invokePayment(for: transaction, with: transaction.payer, then: then)
    }
}

private extension Array where Element == Domain.PaymentChannel {
    
    func tryMap(using mapper: DomainToAPIModelsMapper) -> [Headless.Models.PaymentChannel] {
        self.compactMap { try? mapper.makeHeadlessModelsPaymentChannel(from: $0) }
    }
}
