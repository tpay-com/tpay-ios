//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class EmailAddressValidator_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = EmailAddressValidator(error: .stub)
    
    // MARK: - Tests
    
    func test_ValidEmailAddress() {
        expect(self.sut.validate("email@example.com")) == .success
        expect(self.sut.validate("firstname.lastname@example.com")) == .success
        expect(self.sut.validate("email@subdomain.example.com")) == .success
        expect(self.sut.validate("firstname+lastname@example.com")) == .success
        expect(self.sut.validate("1234567890@example.com")) == .success
        expect(self.sut.validate("email@example-one.com")) == .success
        expect(self.sut.validate("_______@example.com")) == .success
        expect(self.sut.validate("email@example.name")) == .success
        expect(self.sut.validate("email@example.museum")) == .success
        expect(self.sut.validate("email@example.co.jp")) == .success
        expect(self.sut.validate("firstname-lastname@example.com")) == .success
    }
    
    func test_InvalidEmailAdress() {
        expect(self.sut.validate("#@%^%#$@#$@#.com")) == .failure(error: .stub)
        expect(self.sut.validate("@example.com")) == .failure(error: .stub)
        expect(self.sut.validate("Joe Smith <email@example.com>")) == .failure(error: .stub)
        expect(self.sut.validate("email.example.com")) == .failure(error: .stub)
        expect(self.sut.validate("email@example@example.com")) == .failure(error: .stub)
        expect(self.sut.validate(".email@example.com")) == .failure(error: .stub)
        expect(self.sut.validate("email.@example.com")) == .failure(error: .stub)
        expect(self.sut.validate("email..email@example.com")) == .failure(error: .stub)
        expect(self.sut.validate("email@example.com (Joe Smith)")) == .failure(error: .stub)
        expect(self.sut.validate("email@example")) == .failure(error: .stub)
        expect(self.sut.validate("email@111.222.333.44444")) == .failure(error: .stub)
        expect(self.sut.validate("email@example..com")) == .failure(error: .stub)
        expect(self.sut.validate("Abc..123@example.com")) == .failure(error: .stub)
    }
    
}

private extension InputValidationError {
    
    static let stub = InputValidationError(description: "stub")
}
