//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultCardSerializer_Tests: XCTestCase {
 
    // MARK: - Tests
    
    func test_Serialize() {
        let sut = DefaultCardDataSerializer(merchantDomain: Stub.domain)
        
        expect(try sut.serialize(card: Stub.card)) == "1111111111111111|11/11|111|https://merchantapp.online".data(using: .utf8)
        expect(try sut.serialize(card: Stub.card2)) == "1111111111111111|05/11|111|https://merchantapp.online".data(using: .utf8)
    }
}

private extension DefaultCardSerializer_Tests {
    
    enum Stub {
        
        // MARK: - Properties
        
        static let card = Domain.Card(number: "1111111111111111", expiryDate: .init(month: 11, year: 11), securityCode: "111", shouldTokenize: false)
        static let card2 = Domain.Card(number: "1111111111111111", expiryDate: .init(month: 05, year: 11), securityCode: "111", shouldTokenize: false)
        static let domain = "https://merchantapp.online"
    }
}
