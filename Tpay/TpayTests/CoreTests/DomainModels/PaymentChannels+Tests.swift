//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation
import Nimble
@testable import Tpay
import XCTest

final class PaymentChannels_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_TestAvailabilityAgainst_NoConstraints() {
        let sut = Stub.makeStubPaymentChannel(with: [])
        
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.2))) == true
    }
    
    func test_TestAvailabilityAgainst_MinConstraint() {
        let sut = Stub.makeStubPaymentChannel(with: [
            Domain.PaymentChannel.Constraint(field: .amount, type: .min, value: "0.25")
        ])
        
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.2))) == false
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.25))) == true
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.3))) == true
    }
    
    func test_TestAvailabilityAgainst_MaxConstraint() {
        let sut = Stub.makeStubPaymentChannel(with: [
            Domain.PaymentChannel.Constraint(field: .amount, type: .max, value: "0.25")
        ])
        
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.2))) == true
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.25))) == true
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.3))) == false
    }
    
    func test_TestAvailabilityAgainst_MinMaxConstraints() {
        let sut = Stub.makeStubPaymentChannel(with: [
            Domain.PaymentChannel.Constraint(field: .amount, type: .min, value: "0.2"),
            Domain.PaymentChannel.Constraint(field: .amount, type: .max, value: "0.25")
        ])
        
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.2))) == true
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.25))) == true
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.19))) == false
        expect(sut.testAvailabilityAgainst(paymentInfo: Stub.makeStubPaymentInfo(with: 0.3))) == false
    }
}

private extension PaymentChannels_Tests {
    
    enum Stub {
        
        // MARK: - Factories
        
        static func makeStubPaymentInfo(with amount: Double) -> Domain.PaymentInfo {
            .init(amount: amount, title: .empty)
        }
        
        static func makeStubPaymentChannel(with constraints: [Domain.PaymentChannel.Constraint]) -> Domain.PaymentChannel {
            .init(id: .empty, name: .empty, fullName: .empty, imageUrl: nil, associatedGroupId: .unknown, constraints: constraints)
        }
    }
}
