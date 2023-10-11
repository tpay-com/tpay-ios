//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultBanksService_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let store = DefaultPaymentDataStore()
    
    private lazy var sut = DefaultBanksService(paymentDataStore: store)
    
    // MARK: - Tests
    
    func test_storeBanks() {
        store.set(paymentMethods: Stub.paymentMethods)
        expect(self.sut.banks) == Stub.banks
    }
}
 
private extension DefaultBanksService_Tests {
    
    enum Stub {
        static let banks: [Domain.PaymentMethod.Bank] = [.init(id: "1", name: "1", imageUrl: nil)]
        static let paymentMethods: [Domain.PaymentMethod] = [.pbl(Domain.PaymentMethod.Bank(id: "1", name: "1", imageUrl: nil))]
    }
}
