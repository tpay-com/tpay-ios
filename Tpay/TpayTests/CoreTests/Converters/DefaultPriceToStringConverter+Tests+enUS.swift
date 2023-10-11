//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultPriceToStringConverter_Tests_enUS: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultPriceToStringConverter(locale: .enUS)
    
    // MARK: - Tests
    
    func test_StringFrom_1_PLN() {
        expect(self.sut.string(from: .init(amount: 1))) == "PLN 1.00"
    }
    
    func test_StringFrom_4_20_PLN() {
        expect(self.sut.string(from: .init(amount: 4.20))) == "PLN 4.20"
    }
    
    func test_StringFrom_4200_PLN() {
        debugPrint(self.sut.string(from: .init(amount: 4_200)))
        expect(self.sut.string(from: .init(amount: 4_200))) == "PLN 4,200.00"
    }
    
}
