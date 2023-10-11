//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultPriceToStringConverter_Tests_plPL: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultPriceToStringConverter(locale: .plPL)
    
    // MARK: - Tests
    
    func test_StringFrom_1_PLN() {
        expect(self.sut.string(from: .init(amount: 1))) == "1,00 zł"
    }
    
    func test_StringFrom_4_20_PLN() {
        expect(self.sut.string(from: .init(amount: 4.20))) == "4,20 zł"
    }
    
    func test_StringFrom_4200_PLN() {
        debugPrint(self.sut.string(from: .init(amount: 4_200)))
        expect(self.sut.string(from: .init(amount: 4_200))) == "4200,00 zł"
    }
    
}
