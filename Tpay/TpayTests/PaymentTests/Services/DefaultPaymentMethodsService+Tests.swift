//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultPaymentMethodsService_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let configurationManager = DefaultConfigurationManager()
    private let mapper = DefaultAPIToDomainModelsMapper()
    private let store = DefaultPaymentDataStore()
    
    private lazy var sut = DefaultPaymentMethodsService(configurationManager: configurationManager,
                                                        paymentDataStore: store,
                                                        mapper: mapper)
    
    // MARK: - Tests
    
    func test_storeAllMerchantMethodsWithAllAvailable() {
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods
    }
    
    func test_storeMerchantMethodsWithoutAvailableBlik() {
        let availablePaymentMethods = Stub.availablePaymentMethods.filter { $0 != .blik }

        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })
        
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter(.blik)
    }
    
    func test_storeMerchantMethodsWithoutAvailableCard() {
        let availablePaymentMethods = Stub.availablePaymentMethods.filter { $0 != .card }
        
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter(.card)
    }

    func test_storeMerchantMethodsWithoutAvailablePBL() {
        let availablePaymentMethods = Stub.availablePaymentMethods.filter {
            if case .pbl = $0 { return false }
            return true
        }

        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == availablePaymentMethods
    }

    func test_storeMerchantMethodsWithoutAvailableWallets() {
        let availablePaymentMethods = Stub.availablePaymentMethods.filter {
            if case .digitalWallet = $0 { return false }
            return true
        }

        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == [.card, .blik] + Stub.availableBanks
    }

    func test_storeMerchantMethodsWithOneWallet() {
        let availablePaymentMethods = Stub.availablePaymentMethods.filter {
            if case .digitalWallet(let wallet) = $0 { return wallet.kind == .applePay }
            return true
        }

        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == [.card, .blik] + Stub.availableBanks + [.digitalWallet(.init(kind: .applePay))]
    }

    func testStoreMerchantMethodsWithoutBlik() {
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods.filter { $0 != .blik })
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter(.blik)
    }

    func testStoreMerchantMethodsWithoutCard() {
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods.filter { $0 != .card })
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter(.card)
    }

    func testStoreMerchantMethodsWithoutPBL() {
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods.filter { $0 != .pbl })
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == [.card, .blik] + Stub.availableWallets
    }

    func testStoreMerchantMethodsWithoutWallets() {
        configurationManager.set(merchant: Stub.merchant)
        configurationManager.set(paymentMethods: Stub.allMerchantMethods.filter {
            if case .digitalWallet = $0 { return false }
            return true
        })
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })

        expect(self.store.paymentMethods) == [.card, .blik] + Stub.availableBanks
    }

    func testStoreMerchantMethodsWithDuplicateWallets() {
        configurationManager.set(merchant: Stub.merchant)
        let availablePaymentMethods = Stub.availablePaymentMethods + Stub.availableWallets
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: availablePaymentMethods, completion: { _ in })
        
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods
    }
    
    func testStoreMerchantMethodsWithoutMerchant() {
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        expect(self.store.paymentMethods) == []
    }
    
    func testStoreMerchantMethodsWithoutCardConfiguration() {
        configurationManager.set(merchant: Merchant(authorization: Stub.authorization, walletConfiguration: Stub.walletConfiguration))
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter(.card)
    }
    
    func testStoreMerchantMethodsWithoutApplePayConfiguration() {
        configurationManager.set(merchant: Merchant(authorization: Stub.authorization, cardsConfiguration: Stub.cardsConfiguration))
        configurationManager.set(paymentMethods: Stub.allMerchantMethods)
        sut.store(availablePaymentMethods: Stub.availablePaymentMethods, completion: { _ in })
        expect(self.store.paymentMethods) == Stub.availablePaymentMethods.filter { $0 != .digitalWallet(.init(kind: .applePay)) }
    }

}
 
private extension DefaultPaymentMethodsService_Tests {
    
    enum Stub {
        static let availablePaymentMethods: [Domain.PaymentMethod] = [.card, .blik] + availableBanks + availableWallets
        static let availableWallets: [Domain.PaymentMethod] = [.digitalWallet(.init(kind: .applePay))]
        static let availableBanks: [Domain.PaymentMethod] = [.pbl(Domain.PaymentMethod.Bank(id: "1", name: "1", imageUrl: nil)),
            .pbl(Domain.PaymentMethod.Bank(id: "2", name: "2", imageUrl: nil))]
        
        static let allMerchantMethods: [PaymentMethod] = PaymentMethod.allCases
        static let allMerchantWallets = [DigitalWallet.applePay]
        static let authorization = Merchant.Authorization(clientId: "clientId", clientSecret: "clientSecret")
        static let applePayConfiguration = Merchant.WalletConfiguration.ApplePayConfiguration(merchantIdentifier: "merchantId")
        static var cardsConfiguration: Merchant.CardsAPI? = {
            guard let secKey = generateRandomCryptographyKey() else { return nil }
            return Merchant.CardsAPI(publicKey: secKey)
        }()
        static let walletConfiguration = Merchant.WalletConfiguration(applePayConfiguration: Stub.applePayConfiguration)
        static let merchant = Merchant(authorization: Stub.authorization,
                                       cardsConfiguration: Stub.cardsConfiguration,
                                       walletConfiguration: Stub.walletConfiguration)
        
        private static func generateRandomCryptographyKey() -> SecKey? {
            let attributes: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                             kSecAttrKeySizeInBits as String: 256]
            let ecPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, nil)
            guard let ecPrivateKey = ecPrivateKey else {
                return nil
            }
            return SecKeyCopyPublicKey(ecPrivateKey)
        }
    }
}

private extension [Domain.PaymentMethod] {
    
    func filter(_ payment: Domain.PaymentMethod) -> [Domain.PaymentMethod] {
        switch payment {
        case .card:
            return self.filter { $0 != payment }
        case .blik:
            return self.filter { $0 != payment }
        case .pbl:
            return self.filter {
                if case .pbl = $0 { return false }
                return true
            }
        case .digitalWallet:
            return self.filter {
                if case .digitalWallet = $0 { return false }
                return true
            }
        case .installmentPayments:
            return self.filter {
                if case .installmentPayments = $0 { return false }
                return true
            }
        case .unknown:
            return self.filter { $0 != payment }
        }
    }
}
