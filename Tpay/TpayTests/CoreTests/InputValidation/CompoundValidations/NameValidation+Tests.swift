//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NameValidation_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = NameValidation(requiredValue: .requiredValue, invalidLength: .invalidLength, invalidName: .invalidName)
    
    // MARK: - Tests
    
    func test_ValidateInput() {
        expect(self.sut.result) == .notDetermined
        
        sut.validate(.empty)
        expect(self.sut.result) == .notDetermined
        
        sut.validate("John")
        expect(self.sut.result) == .valid
        
        sut.validate("Doe")
        expect(self.sut.result) == .valid
        
        sut.validate("John Doe")
        expect(self.sut.result) == .valid
        
        sut.validate("Anna Maria González")
        expect(self.sut.result) == .valid
        
        sut.validate("John Doe 1")
        expect(self.sut.result) == .valid // valid according to the https://kipsa.atlassian.net/browse/QA-738?focusedCommentId=166169
        
        sut.validate(.empty)
        expect(self.sut.result) == .invalid(.requiredValue)
        
        sut.validate("Ja")
        expect(self.sut.result) == .invalid(.invalidLength)
        
        let stringwithOver255Characters = "Lorem ipsum dolor sit ameta consectetur adipiscing elita Quisque dapibus ut nisi sit amet rutruma Nam ac orci a purus faucibus fermentuma Vivamus sit amet efficitur nullaa Nulla nec luctus tellusa Aliquam in sem non lectus gravida pellen max char ends here"
        sut.validate(stringwithOver255Characters)
        expect(self.sut.result) == .invalid(.invalidLength)
    }

}

private extension InputValidationError {

    static let requiredValue = InputValidationError(description: "requiredValue")
    static let invalidName = InputValidationError(description: "invalidName")
    static let invalidLength = InputValidationError(description: "invalidLength")
}
