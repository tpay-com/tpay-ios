//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Optional_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_ValueOrEmpty() {
        let emptyValue: Int? = nil
        expect(emptyValue.value(or: 1)).to(equal(1))
        
        let notEmptyValue: Int? = 1
        expect(notEmptyValue.value(or: 2)).to(equal(1))
    }
    
    func test_ValueOrThrow() {
        let emptyValue: Int? = nil
        XCTAssertThrowsError(try emptyValue.value(orThrow: ErrorMock()))
        
        let notEmptyValue: Int? = 1
        XCTAssertNoThrow(try notEmptyValue.value(orThrow: ErrorMock()))
        XCTAssertEqual(try notEmptyValue.value(orThrow: ErrorMock()), 1)
    }
    
}

private extension Optional_Extensions_Tests {
    
    struct ErrorMock: Error {}
    
}
