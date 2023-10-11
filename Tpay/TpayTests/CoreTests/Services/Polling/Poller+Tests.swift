//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Poller_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let networkingService = MockNetworkingService()
    private lazy var sut = Poller(for: MockRequest(), using: networkingService)
    
    private let disposer = Disposer()
    
    // MARK: - Tests
    
    func test_Result() {
        let expectation = expectation(description: "pollingResult")
        
        sut.result
            .subscribe(onNext: { _ in expectation.fulfill() })
            .add(to: disposer)
        
        sut.startPolling(every: .milliseconds(100))
        networkingService.invokeSuccess(with: MockRequest.Response(value: 1))
        
        expect(self.networkingService.numberOfRequests).to(equal(1))
        waitForExpectations(timeout: 1)
    }
    
    func test_RequestsRepeating() {
        let expectation = expectation(description: "pollingRepeating")
        
        sut.startPolling(every: .milliseconds(100))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            expect(self?.networkingService.numberOfRequests).to(beGreaterThan(5))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_PollingCancel() {
        let expectation = expectation(description: "pollingCancel")
        
        sut.startPolling(every: .milliseconds(100))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.sut.cancel()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            expect(self?.networkingService.numberOfRequests).to(equal(4))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}

private extension Poller_Tests {
    
    final class MockNetworkingService: NetworkingService {
        
        private(set) var numberOfRequests: Int = 0
        
        // MARK: - Private
        
        private var ongoingRequest: AnyObject?
        
        // MARK: - API
        
        func execute<RequestType, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where RequestType: NetworkRequest, ResponseType == RequestType.ResponseType {
            defer { numberOfRequests += 1 }
            let request = NetworkRequestResult<ResponseType>()
            self.ongoingRequest = request
            return request
        }
        
        func invokeSuccess<ResponseType: Decodable>(with object: ResponseType) {
            guard let ongoingRequest = ongoingRequest as? NetworkRequestResult<ResponseType> else {
                return
            }
            ongoingRequest.handle(success: object)
        }
    }
}

private extension Poller_Tests {
    
    struct MockRequest: NetworkRequest {
        
        typealias ResponseType = Response
        
        var resource = NetworkResource(url: URL(staticString: "https://tpay.com"))
        
    }
}

private extension Poller_Tests.MockRequest {
    
    struct Response: Decodable, Equatable {
        
        let value: Int
    }
}
