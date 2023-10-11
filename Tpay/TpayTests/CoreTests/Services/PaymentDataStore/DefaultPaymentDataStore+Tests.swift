//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultPaymentDataStore_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var sut = DefaultPaymentDataStore()
    
    // MARK: - Tests
    
    func test_ProvidePaymentMethods() {
        sut.set(paymentMethods: Stub.paymentMethods)

        expect(self.sut.paymentMethods) == Stub.paymentMethods
    }
}

private extension DefaultPaymentDataStore_Tests {
    
    enum Stub {
        static let paymentMethods: [Domain.PaymentMethod] = [.blik, .card]
    }
}
