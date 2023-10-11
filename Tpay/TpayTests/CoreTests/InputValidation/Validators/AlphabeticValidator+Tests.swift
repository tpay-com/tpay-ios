//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class AlphabeticValidator_Tests: XCTestCase {
    
    private let sut = AlphabeticValidator(error: .stub)

    // MARK: - Tests
    
    func test_ValidInput() {
        expect(self.sut.validate(.empty)) == .success
        expect(self.sut.validate("aąbcćdeęfghijklłmnoóprsśtuvxyzżź")) == .success
    }
    
    func test_InvalidInput() {
        expect(self.sut.validate("1234567890")) == .failure(error: .stub)
        expect(self.sut.validate("a1")) == .failure(error: .stub)
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
