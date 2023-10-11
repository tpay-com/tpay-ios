//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultTimeIntervalToStringConverter_Tests: XCTestCase {

    // MARK: - Properties
    
    private let sut = DefaultTimeIntervalToStringConverter()
    
    // MARK: - Tests
    
    func test_DurationFromTimeInterval() {
        expect(self.sut.duration(from: .zero)) == "00:00"
        expect(self.sut.duration(from: .second)) == "00:01"
        expect(self.sut.duration(from: 13 * .second)) == "00:13"
        expect(self.sut.duration(from: .minute)) == "01:00"
        expect(self.sut.duration(from: .minute + .second)) == "01:01"
        expect(self.sut.duration(from: .hour)) == "01:00:00"
        expect(self.sut.duration(from: 2 * .hour + 15 * .minute + 45 * .second)) == "02:15:45"
    }

}
