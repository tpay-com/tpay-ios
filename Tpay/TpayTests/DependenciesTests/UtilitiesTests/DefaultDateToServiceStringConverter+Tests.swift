//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultDateToServiceStringConverter_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var sut = DefaultDateToServiceStringConverter(timeZone: TimeZone(secondsFromGMT: 0))
    
    // MARK: - Tests
       
    func test_DateFormat() {
        expect(self.sut.dateString(from: Date(timeIntervalSince1970: 13 * .day))) == "1970-01-14"
        expect(self.sut.dateString(from: Date(timeIntervalSince1970: 13 * .day + 5 * .hour))) == "1970-01-14"
        expect(self.sut.dateString(from: Date(timeIntervalSince1970: 14 * .day - .second))) == "1970-01-14"
    }
    
    func test_DateAndTimeFormat() {
        expect(self.sut.dateAndTimeString(from: Date(timeIntervalSince1970: 13 * .day))) == "1970-01-14T00:00:00.000Z"
        expect(self.sut.dateAndTimeString(from: Date(timeIntervalSince1970: 13 * .day + 5 * .hour))) == "1970-01-14T05:00:00.000Z"
        expect(self.sut.dateAndTimeString(from: Date(timeIntervalSince1970: 14 * .day - .second))) == "1970-01-14T23:59:59.000Z"
    }
    
}
