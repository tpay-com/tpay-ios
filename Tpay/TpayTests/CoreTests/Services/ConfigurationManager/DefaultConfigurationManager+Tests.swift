//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultConfigurationManager_Tests: XCTestCase {
    
    // MARK: - Properties

    private lazy var sut = DefaultConfigurationManager()

    // MARK: - Tests

    func test_DefaultConfiguration() {
        expect_DefaultConfiguration()
    }
    
    func test_ProvideMerchant() {
        sut.set(merchant: Stub.merchant)
        
        expect(self.sut.merchant) == Stub.merchant
    }
    
    func test_ProvidePaymentMethods() {
        sut.set(paymentMethods: Stub.paymentMethods)

        expect(self.sut.paymentMethods) == Stub.paymentMethods
    }
    
    func test_ProvidePreferredLanguage() {
        sut.set(preferredLanguage: Stub.preferredLanguage)

        expect(self.sut.preferredLanguage) == Stub.preferredLanguage
    }
    
    func test_ProvideSupportedLanguages() {
        sut.set(supportedLanguages: Stub.supportedLanguages)

        expect(self.sut.supportedLanguages) == Stub.supportedLanguages
    }
    
    func test_DefaultConfigurationAfterClear() {
        sut.clear()
        
        expect_DefaultConfiguration()
    }
    
    // MARK: - Private
    
    private func expect_DefaultConfiguration() {
        expect(self.sut.merchant).to(beNil())
        expect(self.sut.paymentMethods).to(equal(DefaultConfigurationManager.Defaults.paymentMethods))
        expect(self.sut.preferredLanguage).to(equal(DefaultConfigurationManager.Defaults.preferredLanguage))
        expect(self.sut.supportedLanguages).to(equal(DefaultConfigurationManager.Defaults.supportedLanguages))
    }
}

private extension DefaultConfigurationManager_Tests {
    
    enum Stub {
        
        static let merchant = Merchant(authorization: .init(clientId: "clientId", clientSecret: "clientSecret"))
        static let paymentMethods: [PaymentMethod] = [.blik, .card]
        static let preferredLanguage = Language.en
        static let supportedLanguages = [Language.pl]
        
    }

}
