//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultNumberToServiceString_Tests_DecimalValue: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultNumberToServiceString()
    
    // MARK: - Tests
    
    // MARK: - string(from value: Int) -> String
    
    func test_StringFrom_1() {
        expect(self.sut.string(from: 1 as Decimal)) == "1.00"
    }
    
    func test_StringFrom_Minus1() {
        expect(self.sut.string(from: -1 as Decimal)) == "-1.00"
    }
    
    func test_StringFrom_1_000() {
        expect(self.sut.string(from: 1000 as Decimal)) == "1000.00"
    }
    
    func test_StringFrom_1_234_567() {
        expect(self.sut.string(from: 1234567 as Decimal)) == "1234567.00"
    }
    
    func test_StringFrom_1_WithFractional() {
        expect(self.sut.string(from: 1.13)) == "1.13"
    }
    
    func test_StringFrom_1_000_WithFractional() {
        expect(self.sut.string(from: 1000.13)) == "1000.13"
    }
    
    func test_StringFrom_10_000_WithFractional() {
        expect(self.sut.string(from: 10000.13)) == "10000.13"
    }
    
    func test_StringFrom_10_011_WithFractional() {
        expect(self.sut.string(from: 10011.13131313)) == "10011.13"
    }
    
}
