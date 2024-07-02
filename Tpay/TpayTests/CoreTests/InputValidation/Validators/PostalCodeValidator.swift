//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PostalCodeValidator_Tests: XCTestCase {
    
    private let sut = PostalCodeValidator(error: .stub)

    // MARK: - Tests
    
    func test_ValidInput() {
        expect(self.sut.validate("01-234")) == .success
    }
    
    func test_InvalidInput() {
        expect(self.sut.validate(.empty)) == .failure(error: .stub)
        expect(self.sut.validate("01234")) == .failure(error: .stub)
        expect(self.sut.validate("01-2345")) == .failure(error: .stub)
        expect(self.sut.validate("0-1234")) == .failure(error: .stub)
        expect(self.sut.validate("01 234")) == .failure(error: .stub)
        expect(self.sut.validate("01-234a")) == .failure(error: .stub)
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
