//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class BankGroupDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Tests
    
    func test_ResponseDecoding() throws {
        let payload =
        """
        {
            "groups": {
                "110": {
                    "id": "110",
                    "name": "Inteligo",
                    "img": "https://secure.tpay.com/_/g/110.png",
                    "availablePaymentChannels": [
                        "14",
                        "64"
                    ],
                    "mainChannel": "14"
                },
                "150": {
                    "id": "150",
                    "name": "BLIK",
                    "img": "https://secure.tpay.com/_/g/150.png",
                    "availablePaymentChannels": [
                        "64"
                    ],
                    "mainChannel": "64"
                }
            }
        }
        """
        
        let sut = try jsonDecoder.decode(TransactionsController.BankGroups.Response.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.bankGroups.count).to(equal(2))
    }
}
