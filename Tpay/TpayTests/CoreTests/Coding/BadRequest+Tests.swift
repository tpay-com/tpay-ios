//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class BadRequest_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Tests
    
    func test_BadRequestDecoding() throws {
        let payload =
        """
        {
            "errors": [
                {
                    "errorCode": "invalid_request",
                    "errorMessage": "Malformed auth header",
                    "fieldName": "",
                    "devMessage": "",
                    "docUrl": ""
                }
            ]
        }
        """
        
        let sut = try jsonDecoder.decode(BadRequest.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.errors.count).to(equal(1))
    }
}
