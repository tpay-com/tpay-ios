//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
import Security
@testable import Tpay
import XCTest

final class DefaultConfigurationValidator_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_MissingMerchantConfigurationValidation() {
        let configurationProvider = MockedConfigurationProvider(merchant: nil, merchantDetailsProvider: MockedMerchantDetailsProvider())
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.merchantNotProvided)))
    }
    
    func test_MissingMerchantDetailsConfigurationValidation() {
        let configurationProvider = MockedConfigurationProvider(merchant: Stub.merchant, merchantDetailsProvider: nil)
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.merchantDetailsNotProvided)))
    }
    
    func test_MissingMerchantAndMerchantDetailsConfigurationValidation() {
        let configurationProvider = MockedConfigurationProvider(merchant: nil, merchantDetailsProvider: nil)
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.multiple([.merchantDetailsNotProvided, .merchantNotProvided]))))
    }
    
    func test_MissingCardsConfigurationValidation() {
        let merchant = Merchant(authorization: Stub.authorization, walletConfiguration: Stub.walletConfiguration)
        let configurationProvider = MockedConfigurationProvider(merchant: merchant, merchantDetailsProvider: MockedMerchantDetailsProvider())
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.cardsConfigurationNotProvided)))
    }
    
    func test_MissingApplePayConfigurationValidation() {
        let merchant = Merchant(authorization: Stub.authorization, cardsConfiguration: Stub.cardsConfiguration)
        let configurationProvider = MockedConfigurationProvider(merchant: merchant, merchantDetailsProvider: MockedMerchantDetailsProvider())
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.applePayConfigurationNotProvided)))
    }
    
    func test_MissingPaymentConfigurationsValidation() {
        let configurationProvider = MockedConfigurationProvider(merchant: Stub.baseMerchant, merchantDetailsProvider: MockedMerchantDetailsProvider())
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.invalid(.multiple([.cardsConfigurationNotProvided, .applePayConfigurationNotProvided]))))
    }
    
    func test_ValidConfigurationValidation() {
        let configurationProvider = MockedConfigurationProvider(merchant: Stub.merchant, merchantDetailsProvider: MockedMerchantDetailsProvider())
        let sut = DefaultConfigurationValidator(configurationProvider: configurationProvider)
        
        expect(sut.checkProvidedConfiguration).to(equal(.valid))
    }
}

private extension DefaultConfigurationValidator_Tests {
    
    enum Stub {
        static let authorization = Merchant.Authorization(clientId: "clientId", clientSecret: "clientSecret")
        static let applePayConfiguration = Merchant.WalletConfiguration.ApplePayConfiguration(merchantIdentifier: "merchantId")
        static var cardsConfiguration: Merchant.CardsAPI? = {
            guard let secKey = generateRandomCryptographyKey() else { return nil }
            return Merchant.CardsAPI(publicKey: secKey)
        }()
        static let walletConfiguration = Merchant.WalletConfiguration(applePayConfiguration: Stub.applePayConfiguration)
        static let baseMerchant = Merchant(authorization: authorization)
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
    
    final class MockedConfigurationProvider: ConfigurationProvider {
        
        // MARK: - Properties
        
        var merchant: Merchant?
        var merchantDetailsProvider: MerchantDetailsProvider?
        var paymentMethods: [PaymentMethod]
        var preferredLanguage: Language
        var supportedLanguages: [Language]
        
        // MARK: - Initialzers
        
        init(merchant: Merchant?,
             merchantDetailsProvider: MerchantDetailsProvider?,
             paymentMethods: [PaymentMethod] = PaymentMethod.allCases,
             preferredLanguage: Language = .en,
             supportedLanguages: [Language] = Language.allCases) {
            self.merchant = merchant
            self.merchantDetailsProvider = merchantDetailsProvider
            self.paymentMethods = paymentMethods
            self.preferredLanguage = preferredLanguage
            self.supportedLanguages = supportedLanguages
        }
    }
    
    final class MockedMerchantDetailsProvider: MerchantDetailsProvider {
        func merchantDisplayName(for language: Tpay.Language) -> String {
            "Test_Merchant"
        }
        
        func merchantHeadquarters(for language: Language) -> String? {
            "Test_Headquarters"
        }
        
        func regulationsLink(for language: Tpay.Language) -> URL {
            URL(safeString: "www.apple.com")
        }
    }
}
