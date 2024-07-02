//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PostalCodeValidation_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = PostalCodeValidation(requiredValue: .requiredValue, invalidPostalCode: .invalidPostalCode)
    
    // MARK: - Tests
    
    func test_ValidateInput() {
        expect(self.sut.result) == .notDetermined
        
        sut.validate("01-")
        expect(self.sut.result) == .notDetermined
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
        
        sut.validate("01-23")
        expect(self.sut.result) == .notDetermined
        
        sut.validate("01-234")
        expect(self.sut.result) == .valid
        
        sut.validate("01-23")
        expect(self.sut.result) == .invalid(.invalidPostalCode)
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
        
        sut.validate("01-234")
        expect(self.sut.result) == .valid
    }

}

private extension InputValidationError {

    static let requiredValue = InputValidationError(description: "requiredValue")
    static let invalidPostalCode = InputValidationError(description: "invalidPostalCode")
}
