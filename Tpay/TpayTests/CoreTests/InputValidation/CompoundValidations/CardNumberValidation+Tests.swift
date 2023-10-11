//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class CardNumberValidation_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = CardNumberValidation(requiredValue: .requiredValue, invalidCardNumber: .invalidCardNumber)
    
    // MARK: - Tests
    
    func testValidateInput() {
        expect(self.sut.result) == .notDetermined
        
        sut.validate(.empty)
        expect(self.sut.result) == .notDetermined
        
        sut.validate("5555555555554444")
        expect(self.sut.result) == .valid
        
        sut.validate("4111111111111111")
        expect(self.sut.result) == .valid
        
        sut.validate("1111666655554444")
        expect(self.sut.result) == .invalid(.invalidCardNumber)
        
        sut.validate("1111^%6655sdfsd4")
        expect(self.sut.result) == .invalid(.invalidCardNumber)
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
    }
    
}

private extension InputValidationError {

    static let requiredValue = InputValidationError(description: "requiredValue")
    static let invalidCardNumber = InputValidationError(description: "invalidCardNumber")
}
