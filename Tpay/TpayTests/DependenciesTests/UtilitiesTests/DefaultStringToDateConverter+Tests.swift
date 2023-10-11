//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultStringToDateConverter_Tests: XCTestCase {

    // MARK: - Properties

    private let sut = DefaultStringToDateConverter(timeZone: TimeZone(secondsFromGMT: 0))

    // MARK: - Tests
    
    // MARK: - ISO format
    
    func test_ISOFormat() {
        expect(self.sut.date(from: "1970-01-01T00:00:00.000")) == Date(timeIntervalSince1970: 0)
        expect(self.sut.date(from: "2000-01-01T00:00:00.000")) == Date(timeIntervalSince1970: 946684800)
        expect(self.sut.date(from: "2000-01-01T03:15:00.000")) == Date(timeIntervalSince1970: 946696500)
        expect(self.sut.date(from: "2000-01-01T03:15:00.222")) == Date(timeIntervalSince1970: 946696500.222)
    }
    
    // MARK: - ISO format with trailing `Z` character
    
    func test_ISOFormatWithTrailingZCharacter() {
        expect(self.sut.date(from: "1970-01-01T00:00:00.000Z")) == Date(timeIntervalSince1970: 0)
        expect(self.sut.date(from: "2000-01-01T00:00:00.000Z")) == Date(timeIntervalSince1970: 946684800)
        expect(self.sut.date(from: "2000-01-01T03:15:00.000Z")) == Date(timeIntervalSince1970: 946696500)
        expect(self.sut.date(from: "2000-01-01T03:15:00.222Z")) == Date(timeIntervalSince1970: 946696500.222)
    }
    
    // MARK: - ISO format without mili seconds
    
    func test_ISOFormatWithoutMiliSeconds() {
        expect(self.sut.date(from: "1970-01-01T00:00:00")) == Date(timeIntervalSince1970: 0)
        expect(self.sut.date(from: "2000-01-01T00:00:00")) == Date(timeIntervalSince1970: 946684800)
        expect(self.sut.date(from: "2000-01-01T03:15:00")) == Date(timeIntervalSince1970: 946696500)
    }
    
    // MARK: - Short date format
    
    func test_ShortDateFormat() {
        expect(self.sut.date(from: "1970-01-01")) == Date(timeIntervalSince1970: 0)
        expect(self.sut.date(from: "2000-01-01")) == Date(timeIntervalSince1970: 946684800)
        expect(self.sut.date(from: "2020-07-02")) == Date(timeIntervalSince1970: 1593648000)
    }
    
    // MARK: - Invalid input
    
    func test_InvalidInput() {
        expect(self.sut.date(from: .empty)).to(beNil())
        expect(self.sut.date(from: "today")).to(beNil())
        expect(self.sut.date(from: "2004-13-32")).to(beNil())
        expect(self.sut.date(from: "2000-01-01T25:15:00.000")).to(beNil())
        expect(self.sut.date(from: "2000-01-01T25:15:00")).to(beNil())
    }

}
