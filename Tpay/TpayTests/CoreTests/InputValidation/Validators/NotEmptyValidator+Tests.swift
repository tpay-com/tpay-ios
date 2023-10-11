//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NotEmptyValidator_Tests: XCTestCase {
    
    private let sut = NotEmptyValidator<[Int]>(error: .stub)

    // MARK: - Tests
    
    func test_ValidCollections() {
        let sut = NotEmptyValidator<[Int]>(error: .stub)
        expect(sut.validate([1])) == .success
        expect(sut.validate([10, 2])) == .success
    }

    func test_InvalidCollections() {
        expect(NotEmptyValidator<[Int]>(error: .stub).validate([])) == .failure(error: .stub)
        expect(NotEmptyValidator<Set<Int>>(error: .stub).validate(Set())) == .failure(error: .stub)
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
