//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultDateToStringConverter_Tests_enUS: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = .enUS
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    private lazy var sut = DefaultDateToStringConverter(calendar: calendar)
    
    // MARK: - Tests
    
    // MARK: - differenceString(between firstDate: Date, and secondDate: Date) -> String
    
    func test_1_secondDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 second"
        expect(self.sut.differenceString(between: new, and: old)) == "1 second"
    }
    
    func test_15_secondsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 seconds"
        expect(self.sut.differenceString(between: new, and: old)) == "15 seconds"
    }
    
    func test_1_minuteDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .minute)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 minute"
        expect(self.sut.differenceString(between: new, and: old)) == "1 minute"
    }
    
    func test_15_minutesDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .minute)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 minutes"
        expect(self.sut.differenceString(between: new, and: old)) == "15 minutes"
    }
    
    func test_1_hourDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .hour)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 hour"
        expect(self.sut.differenceString(between: new, and: old)) == "1 hour"
    }
    
    func test_15_hoursDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .hour)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 hours"
        expect(self.sut.differenceString(between: new, and: old)) == "15 hours"
    }
    
    func test_1_dayDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 day"
        expect(self.sut.differenceString(between: new, and: old)) == "1 day"
    }
    
    func test_4_daysDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 4 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "4 days"
        expect(self.sut.differenceString(between: new, and: old)) == "4 days"
    }
    
    func test_1_weekDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 7 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 week"
        expect(self.sut.differenceString(between: new, and: old)) == "1 week"
    }
    
    func test_3_weeksDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 21 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "3 weeks"
        expect(self.sut.differenceString(between: new, and: old)) == "3 weeks"
    }
    
    func test_2_monthsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 63 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "2 months"
        expect(self.sut.differenceString(between: new, and: old)) == "2 months"
    }
    
    func test_2_yearsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 31 * .day * 12 * 2 + .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "2 years"
        expect(self.sut.differenceString(between: new, and: old)) == "2 years"
    }
    
    // MARK: - dateAndTimeString(from date: Date) -> String
    
    func test_DateAndTimeString() {
        let date = Date(timeIntervalSince1970: 0)
        
        expect(self.sut.dateAndTimeString(from: date)) == "1970 Jan 1 at 00:00:00"
    }
    
    // MARK: - func dateString(from date: Date) -> String
    
    func test_DateString() {
        let date = Date(timeIntervalSince1970: 0)
        
        expect(self.sut.dateString(from: date)) == "1970 January 1"
    }
    
}
