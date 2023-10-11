//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class EmailValidation_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = EmailValidation(requiredValue: .requiredValue, invalidEmailAddress: .invalidEmailAddress)
    
    // MARK: - Tests
    
    func test_ValidateInput() {
        expect(self.sut.result) == .notDetermined
        
        sut.validate("some.address@")
        expect(self.sut.result) == .notDetermined
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
        
        sut.validate("some.address@")
        expect(self.sut.result) == .notDetermined
        
        sut.validate("some.address@test.com")
        expect(self.sut.result) == .valid
        
        sut.validate("some.address@")
        expect(self.sut.result) == .invalid(.invalidEmailAddress)
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
        
        sut.validate("some.address@test.com")
        expect(self.sut.result) == .valid
    }

}

private extension InputValidationError {

    static let requiredValue = InputValidationError(description: "requiredValue")
    static let invalidEmailAddress = InputValidationError(description: "invalidEmailAddress")
}
