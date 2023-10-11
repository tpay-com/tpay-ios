//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class ExpiryDate_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_ExpiryDateFromString() {
        expect(Domain.Card.ExpiryDate.make(from: "12/25")).toNot(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "01/01")).toNot(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "01/00")).toNot(beNil())
        
        expect(Domain.Card.ExpiryDate.make(from: "")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "1225")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "12|25")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "12/2500")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "13/25")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "00/25")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "december/twentytwentyfive")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "aa/bb")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "aa/25")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "12/bb")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "1/1")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "1/01")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "01/1")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "-01/-01")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "-01/01")).to(beNil())
        expect(Domain.Card.ExpiryDate.make(from: "01/-01")).to(beNil())
    }
}
