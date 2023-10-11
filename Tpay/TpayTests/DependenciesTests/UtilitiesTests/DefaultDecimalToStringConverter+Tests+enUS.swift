//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultDecimalToStringConverter_Tests_enUS: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultDecimalToStringConverter(locale: .enUS)
    
    // MARK: - Tests
    
    func test_StringFrom_1() {
        expect(self.sut.string(from: 1)) == "1.00"
    }
    
    func test_StringFrom_Minus1() {
        expect(self.sut.string(from: -1)) == "-1.00"
    }
    
    func test_StringFrom_1_000() {
        expect(self.sut.string(from: 1_000)) == "1,000.00"
    }
    
    func test_StringFrom_1_234_567() {
        expect(self.sut.string(from: 1_234_567)) == "1,234,567.00"
    }
    
    func test_StringFrom_1_234_WithFractional() {
        expect(self.sut.string(from: 1_234.57)) == "1,234.57"
    }
    
    func test_StringFrom_1_WithFractional() {
        expect(self.sut.string(from: 1.87191919191)) == "1.87"
    }
    
}
