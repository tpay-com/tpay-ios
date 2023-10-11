//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class BankGroupsResponse_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Tests
    
    func test_GroupDecoding() throws {
        let payload =
        """
        {
            "id": "110",
            "name": "Inteligo",
            "img": "https://secure.tpay.com/_/g/110.png",
            "availablePaymentChannels": [
                "14",
                "64"
            ],
            "mainChannel": "14"
        }
        """
        
        let sut = try jsonDecoder.decode(BankGroupDTO.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.id.rawValue).to(equal("110"))
        expect(sut.name).to(equal("Inteligo"))
        expect(sut.img).to(equal("https://secure.tpay.com/_/g/110.png"))
    }
}
