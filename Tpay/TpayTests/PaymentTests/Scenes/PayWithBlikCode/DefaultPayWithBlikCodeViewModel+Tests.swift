//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultPayWithBlikCodeViewModel_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_PaymentWithValidToken() {
        let model = Mock.Model(aliasToBeRegistered: nil)
        let sut = Self.makeSut(using: model)
        sut.set(blikCode: Stub.validBlikCode)
        
        sut.invokePayment()
        
        expect(model.wasPaymentInvoked) == true
        expect(model.invokedBlikModel?.token) == Stub.validBlikCode
    }
    
    func test_PaymentWithInvalidToken() {
        let model = Mock.Model(aliasToBeRegistered: nil)
        let sut = Self.makeSut(using: model)
        sut.set(blikCode: Stub.invalidBlikCode)
        
        sut.invokePayment()
        
        expect(model.wasPaymentInvoked) == false
    }
    
    func test_ShouldAllowAliasRegistration() {
        let modelWithAliasDefined = Mock.Model(aliasToBeRegistered: Stub.alias)
        let modelWithAliasNotDefined = Mock.Model(aliasToBeRegistered: nil)
       
        expect(Self.makeSut(using: modelWithAliasDefined).shouldAllowAliasRegistration) == true
        expect(Self.makeSut(using: modelWithAliasNotDefined).shouldAllowAliasRegistration) == false
    }
    
    func test_PaymentWithAliasRegistration() {
        let model = Mock.Model(aliasToBeRegistered: Stub.alias)
        let sut = Self.makeSut(using: model)
        
        sut.set(blikCode: Stub.validBlikCode)
        sut.set(shouldRegisterAlias: true)
        sut.invokePayment()
        
        expect(model.wasPaymentInvoked) == true
        expect(model.invokedBlikModel?.token) == Stub.validBlikCode
        expect(model.invokedBlikModel?.alias?.label).to(beNil())
        expect(model.invokedBlikModel?.alias?.value) == Stub.alias.value
    }
    
    func test_PaymentWithAliasRegistrationAndDefinedLabel() {
        let model = Mock.Model(aliasToBeRegistered: Stub.alias)
        let sut = Self.makeSut(using: model)
        
        sut.set(blikCode: Stub.validBlikCode)
        sut.set(shouldRegisterAlias: true)
        sut.set(aliasLabel: Stub.label)
        sut.invokePayment()
        
        expect(model.wasPaymentInvoked) == true
        expect(model.invokedBlikModel?.token) == Stub.validBlikCode
        expect(model.invokedBlikModel?.alias?.label) == Stub.label
        expect(model.invokedBlikModel?.alias?.value) == Stub.alias.value
    }
    
    // MARK: - Private
    
    private static func makeSut(using model: PayWithBlikCodeModel) -> DefaultPayWithBlikCodeViewModel {
        .init(for: Stub.transaction,
              model: model,
              router: DefaultPayWithBlikCodeRouter(),
              isNavigationToOneClickEnabled: false)
    }
}

private extension DefaultPayWithBlikCodeViewModel_Tests {
    
    enum Mock { }
    enum Stub { }
}

private extension DefaultPayWithBlikCodeViewModel_Tests.Stub {
    
    static let transaction = Domain.Transaction(paymentInfo: .init(amount: 0.0, title: .empty, hiddenDescription: nil),
                                                payer: .init(name: .empty, email: .empty, phone: nil, address: nil),
                                                notification: nil)
    
    static let validBlikCode = "123456"
    static let invalidBlikCode = "123"
    static let alias = Domain.Blik.Regular.Alias(value: "test_value", type: .uId)
    static let label = "test_label"
}

private extension DefaultPayWithBlikCodeViewModel_Tests.Mock {
    
    final class Model: PayWithBlikCodeModel {
        
        let aliasToBeRegistered: Tpay.Domain.Blik.Regular.Alias?
        
        private(set) var wasPaymentInvoked = false
        private(set) var invokedBlikModel: Tpay.Domain.Blik.Regular?
        
        // MARK: - Initializers
        
        init(aliasToBeRegistered: Tpay.Domain.Blik.Regular.Alias?) {
            self.aliasToBeRegistered = aliasToBeRegistered
        }
        
        func invokePayment(for transaction: Tpay.Domain.Transaction,
                           with blik: Tpay.Domain.Blik.Regular,
                           then: @escaping Tpay.OngoingTransactionResultHandler) {
            wasPaymentInvoked = true
            invokedBlikModel = blik
        }
    }
}
