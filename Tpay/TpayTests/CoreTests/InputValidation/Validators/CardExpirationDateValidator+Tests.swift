//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

class CardExpiryDateValidator_Tests: XCTestCase {

    private let sut = CardExpiryDateValidator(error: .stub)
    
    func testValid() {
        expect(self.sut.validate("01/22")) == .success
        expect(self.sut.validate("02/23")) == .success
        expect(self.sut.validate("03/24")) == .success
        expect(self.sut.validate("04/25")) == .success
        expect(self.sut.validate("05/26")) == .success
        expect(self.sut.validate("06/2027")) == .success
        expect(self.sut.validate("07/28")) == .success
        expect(self.sut.validate("08/29")) == .success
        expect(self.sut.validate("09/2030")) == .success
        expect(self.sut.validate("10/31")) == .success
        expect(self.sut.validate("11/32")) == .success
        expect(self.sut.validate("12/33")) == .success
        expect(self.sut.validate("12/2025")) == .success
    }

    func testInvalid() {
        expect(self.sut.validate("00/22")) == .failure(error: .stub)
        expect(self.sut.validate("1/22")) == .failure(error: .stub)
        expect(self.sut.validate("0/223")) == .failure(error: .stub)
        expect(self.sut.validate("/22")) == .failure(error: .stub)
        expect(self.sut.validate("0122")) == .failure(error: .stub)
        expect(self.sut.validate("01ds22")) == .failure(error: .stub)
        expect(self.sut.validate("01-22")) == .failure(error: .stub)
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
