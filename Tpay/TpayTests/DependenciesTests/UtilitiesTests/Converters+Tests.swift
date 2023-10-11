//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Converters_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_DependencyContainerReturnDefaultImplementationOfProtocols() {
        expect(Converters.dateToDate).to(beAKindOf(DefaultDateToDateConverter.self))
        expect(Converters.dateToServiceString).to(beAKindOf(DefaultDateToServiceStringConverter.self))
        expect(Converters.dateToString).to(beAKindOf(DefaultDateToStringConverter.self))
        
        expect(Converters.timeIntervalToString).to(beAKindOf(DefaultTimeIntervalToStringConverter.self))
        
        expect(Converters.decimalToString).to(beAKindOf(DefaultDecimalToStringConverter.self))
        expect(Converters.doubleToString).to(beAKindOf(DefaultDoubleToStringConverter.self))
        expect(Converters.integerToString).to(beAKindOf(DefaultIntegerToStringConverter.self))
        
        expect(Converters.numberToServiceString).to(beAKindOf(DefaultNumberToServiceString.self))
        
        expect(Converters.stringToDate).to(beAKindOf(DefaultStringToDateConverter.self))
    }
    
}

