//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NetworkRequestResult_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_handleSuccess() {
        let sut = NetworkRequestResult<StubResponse>()
        let expectation = expectation(description: "success")

        sut.onResult { result in
            switch result {
            case .success: expectation.fulfill()
            default: return
            }
        }
        
        sut.handle(success: StubResponse())
        waitForExpectations(timeout: 1.0)
    }
    
    func test_handleError() {
        let sut = NetworkRequestResult<StubResponse>()
        let expectation = expectation(description: "error")

        sut.onResult { result in
            switch result {
            case .failure: expectation.fulfill()
            default: return
            }
        }
        
        sut.handle(error: StubError.error)
        waitForExpectations(timeout: 1.0)
    }
}

private extension NetworkRequestResult_Tests {
    
    struct StubResponse: Decodable { }
    
    enum StubError: Error {
        case error
    }
}
