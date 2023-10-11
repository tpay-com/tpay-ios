//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class CardToken_Tests: XCTestCase {
 
    // MARK: - Tests
    
    func test_Init() {
        expect(try CardToken(token: .empty, cardTail: "1234", brand: .mastercard)).notTo(throwError())
        
        expect(try CardToken(token: .empty, cardTail: "123", brand: .mastercard)).to(throwError())
        expect(try CardToken(token: .empty, cardTail: "1234 ", brand: .mastercard)).to(throwError())
        expect(try CardToken(token: .empty, cardTail: "aaaa", brand: .mastercard)).to(throwError())
    }
}
