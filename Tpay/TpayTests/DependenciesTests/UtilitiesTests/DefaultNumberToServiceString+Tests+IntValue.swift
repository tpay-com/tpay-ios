//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultNumberToServiceString_Tests_IntValue: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultNumberToServiceString()
    
    // MARK: - Tests
    
    // MARK: - string(from value: Int) -> String
    
    func test_StringFrom_1() {
        expect(self.sut.string(from: 1)) == "1"
    }
    
    func test_StringFrom_Minus1() {
        expect(self.sut.string(from: -1)) == "-1"
    }
    
    func test_StringFrom_1_000() {
        expect(self.sut.string(from: 1_000)) == "1000"
    }
    
    func test_StringFrom_1_234_567() {
        expect(self.sut.string(from: 1_234_567)) == "1234567"
    }
    
}
