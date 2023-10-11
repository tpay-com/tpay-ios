//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation
import Nimble
@testable import Tpay
import XCTest

final class CardExpiryDate_Extensions_Tests: XCTestCase {
 
    func test_CheckIsBackDate() {
        let current = Date(timeIntervalSince1970: 1_689_677_108) // Tue, 18 Jul 2023 10:45:08 GMT
        
        expect(Domain.Card.ExpiryDate(month: 01, year: 02).checkIsBackDate(comparingTo: current)) == true
        expect(Domain.Card.ExpiryDate(month: 06, year: 22).checkIsBackDate(comparingTo: current)) == true
        expect(Domain.Card.ExpiryDate(month: 06, year: 23).checkIsBackDate(comparingTo: current)) == true
        
        expect(Domain.Card.ExpiryDate(month: 07, year: 23).checkIsBackDate(comparingTo: current)) == false
        expect(Domain.Card.ExpiryDate(month: 08, year: 23).checkIsBackDate(comparingTo: current)) == false
        expect(Domain.Card.ExpiryDate(month: 06, year: 24).checkIsBackDate(comparingTo: current)) == false
    }
}
