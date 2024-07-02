//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NoEmojisValidator_Tests: XCTestCase {
    
    private let sut = NoEmojisValidator(error: .stub)

    // MARK: - Tests
    
    func test_ValidInput() {
        expect(self.sut.validate(.empty)) == .success
        expect(self.sut.validate("Hello123$#@ ")) == .success
    }
    
    func test_InvalidInput() {
        expect(self.sut.validate("👋")) == .failure(error: .stub)
        expect(self.sut.validate("Hello123$#@ 👋")) == .failure(error: .stub)
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
