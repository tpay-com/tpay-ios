//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PESELDecoder_Tests: XCTestCase {

    // MRAK: - Properties

    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

    private lazy var sut = PESELDecoder(calendar: calendar)

    // MARK: - Tests
    
    /// In current time zone
    func test_DateForPesel() {
        expect(self.sut.birthDate(from: "123")).to(beNil())
        
        expect(self.sut.birthDate(from: "89052674432")?.description).to(equal("1989-05-26 00:00:00 +0000"))
        expect(self.sut.birthDate(from: "89052677916")?.description).to(equal("1989-05-26 00:00:00 +0000"))
        expect(self.sut.birthDate(from: "02262212775")?.description).to(equal("2002-06-22 00:00:00 +0000"))
        expect(self.sut.birthDate(from: "00462296423")?.description).to(equal("2100-06-22 00:00:00 +0000"))
    }
    
    func test_ValidateInput() {
        expect(self.sut.validate(input: "123")) == false
        expect(self.sut.validate(input: "some")) == false
        expect(self.sut.validate(input: "qwertyuiopa")) == false
        
        expect(self.sut.validate(input: "11111111111")) == true
    }
    
    func test_ControlValue() {
        expect(self.sut.controlValue(from: "123")).to(beNil())
        
        expect(self.sut.controlValue(from: "89052674432")) == 2
        expect(self.sut.controlValue(from: "89052677916")) == 6
    }
    
    func test_CheckSum() {
        expect(self.sut.checkSum(from: "123")).to(beNil())
        
        expect(self.sut.checkSum(from: "89052674432")) == 2
        expect(self.sut.checkSum(from: "89052677916")) == 6
    }

}
