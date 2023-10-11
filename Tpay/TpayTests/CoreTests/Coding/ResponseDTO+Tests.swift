//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class ResponseDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Tests
    
    func test_FailedResponseDecoding() throws {
        let payload =
        """
        {
            "result": "failed",
            "requestId": "26b69f8bc3ad88cb565b",
            "errors": [
                {
                    "errorCode": "invalid_request_body",
                    "errorMessage": "Failed to decode request body",
                    "fieldName": "",
                    "devMessage": "Request body should be a valid JSON string",
                    "docUrl": ""
                }
            ]
        }
        """
        
        let sut = try jsonDecoder.decode(ResponseDTO.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.result).to(equal(.failed))
        expect(sut.requestId).to(equal("26b69f8bc3ad88cb565b"))
    }
    
    func test_SuccessResponseDecoding() throws {
        let payload =
        """
        {
            "result": "success",
            "requestId": "d910c802c4cd16a12578",
            "transactionId": "ta_DpWPJ4eynRgrly9Q",
            "title": "TR-2C3F-63UHYMX",
            "posId": "ps_Bd2n9JwggXoJepM6",
            "status": "pending"
        }
        """
        
        let sut = try jsonDecoder.decode(ResponseDTO.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.result).to(equal(.success))
        expect(sut.requestId).to(equal("d910c802c4cd16a12578"))
    }
}
