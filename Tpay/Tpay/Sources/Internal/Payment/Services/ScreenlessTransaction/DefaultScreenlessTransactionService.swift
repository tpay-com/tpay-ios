//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultScreenlessTransactionService: ScreenlessTransactionService {
    
    // MARK: - Properties
    
    private let authenticationService: AuthenticationService
    private let paymentDataService: PaymentDataService
    private let transactionService: TransactionService
    private let mapper: APIToDomainModelsMapper
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        self.init(authenticationService: DefaultAuthenticationService(resolver: resolver),
                  paymentDataService: DefaultPaymentDataService(resolver: resolver),
                  transactionService: DefaultTransactionService(using: resolver),
                  mapper: DefaultAPIToDomainModelsMapper())
    }
    
    init(authenticationService: AuthenticationService,
         paymentDataService: PaymentDataService,
         transactionService: TransactionService,
         mapper: APIToDomainModelsMapper) {
        self.authenticationService = authenticationService
        self.paymentDataService = paymentDataService
        self.transactionService = transactionService
        self.mapper = mapper
    }
    
    // MARK: - API
    
    func getAvailableBanks(completion: @escaping (Result<[PaymentData.Bank], Error>) -> Void) {
        paymentDataService.getAvailableBanks(then: { [weak self] result in self?.handleBanks(result, then: completion) })
    }
    
    func getAvailableDigitalWallets(completion: @escaping (Result<[DigitalWallet], Error>) -> Void) {
        paymentDataService.getAvailableDigitalWallets(then: { [weak self] result in self?.handleDigitalWallets(result, then: completion) })
    }
    
    func getAvailablePaymentMethods(completion: @escaping (Result<[PaymentMethod], Error>) -> Void) {
        paymentDataService.getAvailablePaymentMethods(then: { [weak self] result in self?.handlePaymentMethods(result, then: completion) })
    }
    
    func invokePayment(with cardPaymentData: PaymentData.Card,
                       amount: Double,
                       payer: Payer,
                       then: @escaping (Result<TransactionId, Error>) -> Void) {
        if let card = cardPaymentData.card {
            invokePayment(with: card, amount: amount, payer: payer, then: then)
        } else if let token = cardPaymentData.token {
            invokePayment(with: token, amount: amount, payer: payer, then: then)
        } else {
            then(.failure(ScreenlessTransactionError.incorrectCardData))
        }
    }
    
    func invokePayment(with blikPaymentData: PaymentData.Blik,
                       amount: Double,
                       payer: Payer,
                       then: @escaping (Result<TransactionId, Error>) -> Void) {
        if let blikToken = blikPaymentData.blikToken {
            invokePayment(with: blikToken, amount: amount, payer: payer, then: then)
        } else if let blikAlias = blikPaymentData.aliases {
            invokePayment(with: blikAlias, amount: amount, payer: payer, then: then)
        } else {
            then(.failure(ScreenlessTransactionError.incorrectBlikData))
        }
    }
    
    func invokePayment(with bank: PaymentData.Bank,
                       amount: Double,
                       payer: Payer,
                       then: @escaping (Result<TransactionUrl, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "Bank"),
                                             payer: mapper.makePayer(from: payer))
        let bank = mapper.makeBank(from: bank)
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in self?.handleAuthenticate(result, transaction: transaction, bank: bank, then: then) })
    }
    
    func invokePayment(with digitalWallet: PaymentData.DigitalWallet,
                       amount: Double,
                       payer: Payer,
                       then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch digitalWallet {
        case .applePay(let applePayModel):
            invokePayment(with: applePayModel, amount: amount, payer: payer, then: then)
        }
    }
    
    // MARK: - Private
    
    private func invokePayment(with card: PaymentData.Card.CardDetails,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "Card"),
                                             payer: mapper.makePayer(from: payer))
        let card = mapper.makeCard(from: card)
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in self?.handleAuthenticate(result, transaction: transaction, card: card, then: then) })
    }
    
    private func invokePayment(with cardToken: CardToken,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "CardToken"),
                                             payer: mapper.makePayer(from: payer))
        let cardToken = mapper.makeCardToken(from: cardToken)
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in
                self?.handleAuthenticate(result, transaction: transaction, cardToken: cardToken, then: then)
            })
    }
    
    private func invokePayment(with blikToken: BlikToken,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "BlikToken"),
                                             payer: mapper.makePayer(from: payer))
        let blik = Domain.Blik.Regular(token: blikToken, alias: nil)
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in self?.handleAuthenticate(result, transaction: transaction, blik: blik, then: then) })
    }
    
    private func invokePayment(with blikAlias: RegisteredBlikAlias,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "BlikAlias"),
                                             payer: mapper.makePayer(from: payer))
        let blik = Domain.Blik.OneClick(alias: mapper.makeBlikAlias(from: blikAlias))
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in self?.handleAuthenticate(result, transaction: transaction, blik: blik, then: then) })
    }
    
    private func invokePayment(with applePayModel: PaymentData.DigitalWallet.ApplePayModel,
                               amount: Double,
                               payer: Payer,
                               then: @escaping (Result<TransactionId, Error>) -> Void) {
        let transaction = Domain.Transaction(paymentInfo: Domain.PaymentInfo(amount: amount, title: "ApplePay"),
                                             payer: mapper.makePayer(from: payer))
        let applePayToken = Domain.ApplePayToken(token: applePayModel.token)
        
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in
                self?.handleAuthenticate(result, transaction: transaction, applePayToken: applePayToken, then: then)
            })
    }
    
    // MARK: - Handle methods
    
    private func handlePaymentMethods(_ result: Result<[Domain.PaymentMethod], Error>, then: @escaping (Result<[PaymentMethod], Error>) -> Void) {
        switch result {
        case .success(let paymentMethods):
            let methods = paymentMethods.compactMap {
                do {
                    return try makePaymentMethod(from: $0)
                    
                } catch {
                    Logger.info(error.localizedDescription)
                    return nil
                }
            }
            then(.success(methods))
        case .failure(let error): then(.failure(error))
        }
    }
    
    private func handleDigitalWallets(_ result: Result<[Domain.PaymentMethod.DigitalWallet], Error>,
                                      then: @escaping (Result<[DigitalWallet], Error>) -> Void) {
        switch result {
        case .success(let wallets):
            let digitalWallets = wallets.compactMap {
                do {
                    return try makeWallet(from: $0.kind)
                } catch {
                    Logger.info(error.localizedDescription)
                    return nil
                }
            }
            then(.success(digitalWallets))
        case .failure(let error): then(.failure(error))
        }
    }
    
    private func handleBanks(_ result: Result<[Domain.PaymentMethod.Bank], Error>,
                             then: @escaping (Result<[PaymentData.Bank], Error>) -> Void) {
        switch result {
        case .success(let banks): then(.success(banks.compactMap { makeBank(from: $0) }))
        case .failure(let error): then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    card: Domain.Card,
                                    then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: card, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    cardToken: Domain.CardToken,
                                    then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: cardToken, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    blik: Domain.Blik.Regular,
                                    then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: blik, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    blik: Domain.Blik.OneClick,
                                    then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: blik, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    bank: Domain.PaymentMethod.Bank,
                                    then: @escaping (Result<TransactionUrl, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: bank, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleAuthenticate(_ result: Result<Void, Error>,
                                    transaction: Domain.Transaction,
                                    applePayToken: Domain.ApplePayToken,
                                    then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success:
            transactionService.invokePayment(for: transaction, with: applePayToken, then: { [weak self] transactionResult in
                self?.handleTransaction(transactionResult, then: then)
            })
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func handleTransaction(_ result: OngoingTransactionResult,
                                   then: @escaping (Result<TransactionId, Error>) -> Void) {
        switch result {
        case .success(let transaction): then(.success(transaction.transactionId))
        case .failure(let error): then(.failure(error))
        }
    }
    
    private func handleTransaction(_ result: OngoingTransactionResult,
                                   then: @escaping (Result<URL, Error>) -> Void) {
        switch result {
        case .success(let transaction):
            guard let url = transaction.continueUrl else {
                then(.failure(ScreenlessTransactionError.incorrectUrl))
                return
            }
            then(.success(url))
        case .failure(let error):
            then(.failure(error))
        }
    }
    
    private func makeBank(from bank: Domain.PaymentMethod.Bank) -> PaymentData.Bank {
        PaymentData.Bank(id: bank.id, name: bank.name, imageUrl: bank.imageUrl)
    }
    
    private func makeDigitalWallet(from wallet: Domain.PaymentMethod.DigitalWallet) throws -> DigitalWallet {
        switch wallet.kind {
        case .applePay:
            return .applePay
        case .googlePay:
            return .googlePay
        case .payPal:
            return .payPal
        case .unknown:
            throw ScreenlessTransactionError.unknownDigitalWallet
        }
    }
    
    private func makePaymentMethod(from paymentMethod: Domain.PaymentMethod) throws -> PaymentMethod {
        switch paymentMethod {
        case .blik:
            return .blik
        case .pbl:
            return .pbl
        case .card:
            return .card
        case .digitalWallet(let wallet):
            return .digitalWallet(try makeWallet(from: wallet.kind))
        case .unknown:
            throw ScreenlessTransactionError.unknownPaymentMethod
        }
    }
    
    private func makeWallet(from wallet: Domain.PaymentMethod.DigitalWallet.Kind) throws -> DigitalWallet {
        switch wallet {
        case .googlePay:
            return .googlePay
        case .applePay:
            return .applePay
        case .payPal:
            return .payPal
        case .unknown:
            throw ScreenlessTransactionError.unknownDigitalWallet
        }
    }
}
