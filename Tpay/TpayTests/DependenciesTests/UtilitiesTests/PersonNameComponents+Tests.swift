//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation
import Nimble
@testable import Tpay
import XCTest

final class PersonNameComponents_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultPersonNameComponentsToStringConverter()
    
    // MARK: - Tests
    
    func test_StringFrom_JohnDoe() {
        var components = PersonNameComponents()
        components.givenName = "John"
        components.familyName = "Doe"
        expect(self.sut.string(from: components)) == "John Doe"
    }
    
    func test_StringFrom_Doe() {
        var components = PersonNameComponents()
        components.familyName = "Doe"
        expect(self.sut.string(from: components)).to(beNil())
    }
    
    func test_StringFrom_John() {
        var components = PersonNameComponents()
        components.givenName = "John"
        expect(self.sut.string(from: components)).to(beNil())
    }
    
}
