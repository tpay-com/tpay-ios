//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultDateToDateConverter_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    private lazy var sut = DefaultDateToDateConverter(calendar: calendar)
    
    // MARK: - Tests
    
    // MARK: - Initializers
    
    func test_DefaultInitializer() {
        let calendar = Calendar.current
        let sut = DefaultDateToDateConverter()
        
        let passedDate = Date(timeIntervalSince1970: 13 * .hour + .day)
        let timeZoneOffset = calendar.timeZone.secondsFromGMT(for: passedDate)
        
        expect(sut.startOfDay(from: passedDate)) == Date(timeIntervalSince1970: .day - Double(timeZoneOffset))
        expect(sut.endOfDay(from: passedDate)) == Date(timeIntervalSince1970: 2 * .day - .second - Double(timeZoneOffset))
        
        expect(sut.date(byAdding: 1, .second, to: passedDate)) == Date(timeIntervalSince1970: 13 * .hour + .day + .second)
        expect(sut.date(byAdding: 1, .day, to: passedDate)) == Date(timeIntervalSince1970: 13 * .hour + 2 * .day)
    }
    
    // MARK: - startOfDay(from: Date) -> Date
    
    func test_StartOfDay() {
        let passedDate = Date(timeIntervalSince1970: 13 * .hour + .day)
        let expectedDate = Date(timeIntervalSince1970: .day)
        
        expect(self.sut.startOfDay(from: passedDate)) == expectedDate
    }
    
    // MARK: - endOfDay(from: Date) -> Date
    
    func test_EndOfDay() {
        let passedDate = Date(timeIntervalSince1970: 2 * .hour)
        let expectedDate = Date(timeIntervalSince1970: .day - .second)
        
        expect(self.sut.endOfDay(from: passedDate)) == expectedDate
    }
    
    // MARK: - date(byAdding value: Int, _ component: Calendar.Component, to date: Date) -> Date
    
    func test_DateByAddingComponentValueToDate() {
        let passedDate = Date(timeIntervalSince1970: 2 * .hour)
        let expectedDate = Date(timeIntervalSince1970: 2 * .day + 2 * .hour)
        
        expect(self.sut.date(byAdding: 2, .day, to: passedDate)) == expectedDate
    }
    
}
