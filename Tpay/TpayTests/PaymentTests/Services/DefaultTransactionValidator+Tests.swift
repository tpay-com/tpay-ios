//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultTransactionValidator_Tests: XCTestCase {
    
    private let sut = DefaultTransactionValidator()
    
    // MARK: - Tests
    
    func test_Validate() {
        expect(try self.sut.validate(transaction: .Factory.make(with: []))).notTo(throwError())
        expect(try self.sut.validate(transaction: .Factory.make(with: [Stub.ambiguousBlikAliasError]))).to(throwError())
        
        expect(try self.sut.validate(transaction: .Factory.make(with: Stub.orderedErrors))).to(throwError(Stub.ambiguousBlikAliasError))
        expect(try self.sut.validate(transaction: .Factory.make(with: Stub.unorderedErrors))).to(throwError(Stub.ambiguousBlikAliasError))
    }
}

private extension Domain.OngoingTransaction {
    
    enum Factory {
        
        static func make(with paymentErrors: [Domain.OngoingTransaction.PaymentError]) -> Domain.OngoingTransaction {
            .init(transactionId: .empty,
                  status: .pending,
                  notification: nil,
                  continueUrl: nil,
                  paymentErrors: paymentErrors)
        }
    }
}

private extension DefaultTransactionValidator_Tests {
    
    enum Stub {
        
        static let ambiguousBlikAliasError = Domain.OngoingTransaction.PaymentError.ambiguousBlikAlias(alternatives: [])
        static let attemptError = Domain.OngoingTransaction.PaymentError.attemptError(code: .empty)
        static let invalidData = Domain.OngoingTransaction.PaymentError.invalidData(description: .empty)
        
        static let orderedErrors: [Domain.OngoingTransaction.PaymentError] = [Self.ambiguousBlikAliasError, Self.attemptError, Self.invalidData]
        static let unorderedErrors: [Domain.OngoingTransaction.PaymentError] = [Self.invalidData, Self.attemptError, Self.ambiguousBlikAliasError]
    }
}
