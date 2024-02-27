//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultScreenlessTransactionService_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var sut = DefaultScreenlessTransactionService(authenticationService: MockAuthenticationService(),
                                                               paymentDataService: MockPaymentDataService(),
                                                               transactionService: MockTransactionService(),
                                                               mapper: DefaultAPIToDomainModelsMapper())
    
    // MARK: - Tests
    
    func test_getAvailableBanks() {
        let expectation = expectation(description: "getAvailableBanks")

        sut.getAvailableBanks(completion: { result in
            guard case let .success(banks) = result else { return }
            expect(banks) == Stub.banks
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_getAvailablePaymentMethods() {
        let expectation = expectation(description: "getPaymentMethods")
        
        sut.getAvailablePaymentMethods(completion: { result in
            guard case let .success(paymentMethods) = result else { return }
            expect(paymentMethods) == Stub.paymentMethods
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_getAvailableWallets() {
        let expectation = expectation(description: "getAvailableDigitalWallets")
        
        sut.getAvailableDigitalWallets(completion: { result in
            guard case let .success(wallets) = result else { return }
            expect(wallets) == Stub.digitalWallets
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithCardData() {
        let expectation = expectation(description: "invokePaymentWithCardDetails")
        let card = PaymentData.Card(card: Stub.cardDetails, token: nil)
        
        sut.invokePayment(with: card, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionId) = result else { return }
            expect(transactionId) == Stub.transactionId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithCardToken() {
        let expectation = expectation(description: "invokePaymentWithCardToken")
        let card = PaymentData.Card(card: nil, token: Stub.cardToken)
        
        sut.invokePayment(with: card, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionId) = result else { return }
            expect(transactionId) == Stub.transactionId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithCardError() {
        let expectation = expectation(description: "invokePaymentWithCardError")
        let card = PaymentData.Card(card: nil, token: nil)
        
        sut.invokePayment(with: card, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .failure(error) = result else { return }
            expect(error).to(matchError(ScreenlessTransactionError.incorrectCardData))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithBlikToken() {
        let expectation = expectation(description: "invokePaymentWithBlikToken")
        let blik = PaymentData.Blik(blikToken: Stub.blikToken, aliases: nil)
        
        sut.invokePayment(with: blik, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionId) = result else { return }
            expect(transactionId) == Stub.transactionId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithBlikAlias() {
        let expectation = expectation(description: "invokePaymentWithBlikAlias")
        let blik = PaymentData.Blik(blikToken: nil, aliases: Stub.blikAlias)
        
        sut.invokePayment(with: blik, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionId) = result else { return }
            expect(transactionId) == Stub.transactionId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithBlikError() {
        let expectation = expectation(description: "invokePaymentWithBlikError")
        let blik = PaymentData.Blik(blikToken: nil, aliases: nil)
        
        sut.invokePayment(with: blik, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .failure(error) = result else { return }
            expect(error).to(matchError(ScreenlessTransactionError.incorrectBlikData))
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithPBL() {
        let expectation = expectation(description: "invokePaymentWithPBL")
        
        sut.invokePayment(with: Stub.bank, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionUrl) = result else { return }
            expect(transactionUrl) == Stub.transactionUrl
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_invokePaymentWithApplePay() {
        let expectation = expectation(description: "invokePaymentWithApplePay")
        let digitalWallet = PaymentData.DigitalWallet.applePay(PaymentData.DigitalWallet.ApplePayModel(token: Stub.applePayToken))
        
        sut.invokePayment(with: digitalWallet, amount: 4.20, payer: Stub.payer, then: { result in
            guard case let .success(transactionId) = result else { return }
            expect(transactionId) == Stub.transactionId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
    }
    
}

extension DefaultScreenlessTransactionService_Tests {
    
    final class MockAuthenticationService: AuthenticationService {
        
        func authenticate(then: @escaping Tpay.Completion) {
            then(.success(()))
        }
    }
}

extension DefaultScreenlessTransactionService_Tests {
    
    final class MockPaymentDataService: PaymentDataService {
        
        func fetchBankGroups(then: @escaping Tpay.Completion) {
            then(.success(()))
        }
        
        func fetchChannels(then: @escaping Completion) {
            then(.success(()))
        }
        
        func getAvailableBanks(then: @escaping (Result<[Tpay.Domain.PaymentMethod.Bank], Error>) -> Void) {
            then(.success(Stub.domainBanks))
        }
        
        func getAvailablePaymentMethods(then: @escaping (Result<[Tpay.Domain.PaymentMethod], Error>) -> Void) {
            then(.success(Stub.domainPaymentMethods))
        }
        
        func getAvailableDigitalWallets(then: @escaping (Result<[Domain.PaymentMethod.DigitalWallet], Error>) -> Void) {
            then(.success(Stub.domainWallets))
        }
    }
}

extension DefaultScreenlessTransactionService_Tests {
    
    final class MockTransactionService: TransactionService {
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with blik: Tpay.Domain.Blik.Regular,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with blik: Tpay.Domain.Blik.OneClick,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with card: Tpay.Domain.Card,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with cardToken: Tpay.Domain.CardToken,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with pbl: Tpay.Domain.PaymentMethod.Bank,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithURL))
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with applePay: Tpay.Domain.ApplePayToken,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func invokePayment(for transaction: Domain.Transaction, with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
        
        func continuePayment(for ongoingTransaction: Domain.OngoingTransaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler) {
            then(.success(Stub.transactionWithId))
        }
    }
}

private extension DefaultScreenlessTransactionService_Tests {
    
    enum Stub {
        static let domainBanks: [Domain.PaymentMethod.Bank] = [.init(id: "1", name: "1", imageUrl: nil), .init(id: "2", name: "2", imageUrl: nil)]
        static let domainPaymentMethods: [Domain.PaymentMethod] = [.blik, .card, .digitalWallet(.init(kind: .applePay))]
        static let domainWallets: [Domain.PaymentMethod.DigitalWallet] = [.init(kind: .applePay)]
        static let banks: [PaymentData.Bank] = [.init(id: "1", name: "1", imageUrl: nil), .init(id: "2", name: "2", imageUrl: nil)]
        static let paymentMethods: [PaymentMethod] = [.blik, .card, .digitalWallet(.applePay)]
        static let digitalWallets: [DigitalWallet] = [.applePay]
        static let transactionWithId = Domain.OngoingTransaction(transactionId: transactionId, status: .correct, continueUrl: nil, paymentErrors: nil)
        static let transactionWithURL = Domain.OngoingTransaction(transactionId: .empty, status: .correct, continueUrl: transactionUrl, paymentErrors: nil)
        static let transactionId = "transactionId"
        static let transactionUrl = URL(string: "transactionUrl")
        static let cardDetails = PaymentData.Card.CardDetails(number: "1",
                                                              expiryDate: .init(month: 12, year: 23),
                                                              securityCode: "1234",
                                                              shouldSave: false)
        static let cardToken = try? CardToken(token: "12345", cardTail: "1234", brand: .mastercard)
        static let payer = Payer(name: "Test User", email: "test@tpay.test")
        static let blikToken = "123456"
        static let applePayToken = "123456"
        static let blikAlias = RegisteredBlikAlias(value: .uid("blikAlias"))
        static let bank = PaymentData.Bank(id: "1", name: "1", imageUrl: nil)
    }
}
