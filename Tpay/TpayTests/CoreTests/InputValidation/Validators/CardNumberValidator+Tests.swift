//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class CardNumberValidator_Tests: XCTestCase {
    
    private let sut = CardNumberValidator(error: .stub)
    
    // MARK: - Tests
    
    func test_MastercardValid() {
        expect(self.sut.validate("5555555555554444")) == .success // Mastercard 16-digit
        expect(self.sut.brand) == .mastercard
        expect(self.sut.validate("5105105105105100")) == .success
        expect(self.sut.brand) == .mastercard
    }
    
    func test_MasterCardInvalid() {
        expect(self.sut.validate("4111111111111111")) == .success
        expect(self.sut.brand) != .mastercard
        expect(self.sut.validate("1111666655554444")) == .failure(error: .stub)
        expect(self.sut.brand) != .mastercard
        expect(self.sut.validate("55555555555544443")) == .failure(error: .stub)
        expect(self.sut.brand) != .mastercard
        expect(self.sut.validate("40128888")) == .failure(error: .stub)
        expect(self.sut.brand).to(beNil())
    }
    
    func test_VisaValid() {
        expect(self.sut.validate("4111111111111")) == .success // Visa 13-digit
        expect(self.sut.brand) == .visa
        expect(self.sut.validate("4111111111111111")) == .success // Visa 16-digit
        expect(self.sut.brand) == .visa
        expect(self.sut.validate("4111111111111111111")) == .success // Visa 19-digit
        expect(self.sut.brand) == .visa
        expect(self.sut.validate("4012888888881881")) == .success
        expect(self.sut.brand) == .visa
    }
    
    func test_VisaInvalid() {
        expect(self.sut.validate("5555555555554444")) == .success
        expect(self.sut.brand) != .visa
        expect(self.sut.validate("5105105105105100")) == .success
        expect(self.sut.brand) != .visa
        expect(self.sut.validate("40128888")) == .failure(error: .stub)
        expect(self.sut.brand).to(beNil())
    }
    
    func test_OtherInvalid() {
        expect(self.sut.validate("1111666655554444")) == .failure(error: .stub)
        expect(self.sut.brand) == .other
        expect(self.sut.validate("9999888877776666")) == .failure(error: .stub)
        expect(self.sut.brand) == .other
        expect(self.sut.validate("3530111333300000")) == .failure(error: .stub)
        expect(self.sut.brand) == .other
    }
    
    func test_Invalid() {
        expect(self.sut.validate("")) == .failure(error: .stub)
        expect(self.sut.validate("23245675")) == .failure(error: .stub)
        expect(self.sut.validate("55554444")) == .failure(error: .stub)
        expect(self.sut.validate("5555*4444")) == .failure(error: .stub)
        expect(self.sut.validate("5555K4444")) == .failure(error: .stub)
        expect(self.sut.brand).to(beNil())
    }
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
