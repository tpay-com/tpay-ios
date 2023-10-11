//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultDateToStringConverter_Tests_plPL: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = .plPL
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    private lazy var sut = DefaultDateToStringConverter(calendar: calendar)
    private lazy var os = ProcessInfo().operatingSystemVersion
    
    // MARK: - Tests
    
    // MARK: - differenceString(between firstDate: Date, and secondDate: Date) -> String
    
    func test_1_secondDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 sekunda"
        expect(self.sut.differenceString(between: new, and: old)) == "1 sekunda"
    }
    
    func test_15_secondsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 sekund"
        expect(self.sut.differenceString(between: new, and: old)) == "15 sekund"
    }
    
    func test_1_minuteDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .minute)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 minuta"
        expect(self.sut.differenceString(between: new, and: old)) == "1 minuta"
    }
    
    func test_15_minutesDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .minute)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 minut"
        expect(self.sut.differenceString(between: new, and: old)) == "15 minut"
    }
    
    func test_1_hourDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .hour)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 godzina"
        expect(self.sut.differenceString(between: new, and: old)) == "1 godzina"
    }
    
    func test_15_hoursDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 15 * .hour)
        
        expect(self.sut.differenceString(between: old, and: new)) == "15 godzin"
        expect(self.sut.differenceString(between: new, and: old)) == "15 godzin"
    }
    
    func test_1_dayDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: .day)
        
        switch (os.majorVersion, os.minorVersion, os.patchVersion) {
        case (15, _, _):
            expect(self.sut.differenceString(between: old, and: new)) == "1 doba"
            expect(self.sut.differenceString(between: new, and: old)) == "1 doba"
        default:
            expect(self.sut.differenceString(between: old, and: new)) == "1 dzień"
            expect(self.sut.differenceString(between: new, and: old)) == "1 dzień"
        }
    }
    
    func test_4_daysDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 4 * .day)
        
        switch (os.majorVersion, os.minorVersion, os.patchVersion) {
        case (15, _, _):
            expect(self.sut.differenceString(between: old, and: new)) == "4 doby"
            expect(self.sut.differenceString(between: new, and: old)) == "4 doby"
        default:
            expect(self.sut.differenceString(between: old, and: new)) == "4 dni"
            expect(self.sut.differenceString(between: new, and: old)) == "4 dni"
        }
    }
    
    func test_1_weekDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 7 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 tydzień"
        expect(self.sut.differenceString(between: new, and: old)) == "1 tydzień"
    }
    
    func test_3_weeksDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 21 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "3 tygodnie"
        expect(self.sut.differenceString(between: new, and: old)) == "3 tygodnie"
    }
    
    func test_2_monthsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 63 * .day)
        
        expect(self.sut.differenceString(between: old, and: new)) == "2 miesiące"
        expect(self.sut.differenceString(between: new, and: old)) == "2 miesiące"
    }
    
    func test_1_yearDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 31 * .day * 12 + .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "1 rok"
        expect(self.sut.differenceString(between: new, and: old)) == "1 rok"
    }
    
    func test_2_yearsDiff() {
        let old = Date(timeIntervalSince1970: 0)
        let new = Date(timeIntervalSince1970: 31 * .day * 12 * 2 + .second)
        
        expect(self.sut.differenceString(between: old, and: new)) == "2 lata"
        expect(self.sut.differenceString(between: new, and: old)) == "2 lata"
    }
    
    // MARK: - dateAndTimeString(from date: Date) -> String
    
    func test_DateAndTimeString() {
        let date = Date(timeIntervalSince1970: 0)
        
        expect(self.sut.dateAndTimeString(from: date)) == "01.01.1970 o 00:00:00"
    }
    
    // MARK: - func dateString(from date: Date) -> String
    
    func test_DateString() {
        let date = Date(timeIntervalSince1970: 0)
        
        expect(self.sut.dateString(from: date)) == "1 stycznia 1970"
    }
    
}
