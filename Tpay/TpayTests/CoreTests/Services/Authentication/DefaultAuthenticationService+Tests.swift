//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultAuthenticationService_Tests: XCTestCase {

    // MARK: - Properties

    private let credentialsManager = DefaultCredentialsManager()
    private let networkingService = MockNetworkingService()
    private let dateProvider = MockDateProvider(now: Date(timeIntervalSince1970: 1_700_000_000))

    private lazy var sut = DefaultAuthenticationService(using: networkingService,
                                                        credentialsStore: credentialsManager,
                                                        credentialsProvider: credentialsManager,
                                                        dateProvider: dateProvider)

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        credentialsManager.store(credentials: Self.credentials)
    }

    // MARK: - Tests: cache and expiry

    func test_ValidCachedToken_DoesNotHitTheService() {
        store(claims: makeCacheableClaims(expiringIn: 7_200))

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(0))
    }

    func test_ExpiredCachedToken_FetchesNewToken() {
        store(claims: makeCacheableClaims(expiringIn: -1))

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_CachedTokenInsideRefreshMargin_FetchesNewToken() {
        store(claims: makeCacheableClaims(expiringIn: AuthorizationClaims.refreshMargin - 30))

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_FetchedToken_IsReusedByTheNextCall() {
        authenticateAndWait()
        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(1))
        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
    }

    func test_CacheHit_CompletesAsynchronouslyOnTheServiceQueue() {
        store(claims: makeCacheableClaims(expiringIn: 7_200))

        let expectation = expectation(description: "authenticated")
        var queueLabel: String?

        sut.authenticate { _ in
            queueLabel = String(cString: __dispatch_queue_get_label(nil))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
        expect(queueLabel).to(equal("com.tpay.authentication"))
    }

    // MARK: - Tests: token lifetime

    func test_ResponseWithoutExpiresIn_StoresNonCacheableToken() {
        networkingService.response = AuthorizationController.Authorize.Response(accessToken: Self.accessToken, expiresIn: nil)

        authenticateAndWait()
        authenticateAndWait()

        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
        expect(self.credentialsManager.claims?.expiresAt).to(beNil())
        expect(self.networkingService.requestCount).to(equal(2))
    }

    func test_FetchedToken_ExpiresAtIsCountedFromTheLocalClock() {
        authenticateAndWait()

        expect(self.credentialsManager.claims?.expiresAt).to(equal(self.dateProvider.now.addingTimeInterval(7_200)))
    }

    // MARK: - Tests: credentials the token belongs to

    func test_ChangedClientId_InvalidatesCache() {
        store(claims: makeCacheableClaims(expiringIn: 7_200))
        credentialsManager.store(credentials: AuthorizationCredentials(user: "other-client", password: "secret"))

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_RotatedClientSecret_InvalidatesCache() {
        store(claims: makeCacheableClaims(expiringIn: 7_200))
        credentialsManager.store(credentials: AuthorizationCredentials(user: "client", password: "rotated-secret"))

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_MissingCredentials_AuthenticatesWithoutCaching() {
        credentialsManager.removeCredentials()

        authenticateAndWait()

        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
        expect(self.credentialsManager.claims?.issuedFor).to(beNil())

        authenticateAndWait()

        expect(self.networkingService.requestCount).to(equal(2))
    }

    func test_CredentialsChangedWhileRequestInFlight_StoresNonCacheableToken() {
        let requestStarted = expectation(description: "request in flight")
        networkingService.holdsRequests = true
        networkingService.onRequestStarted = { requestStarted.fulfill() }

        let authenticated = expectation(description: "authenticated")
        sut.authenticate { _ in authenticated.fulfill() }

        wait(for: [requestStarted], timeout: 2.0)
        credentialsManager.store(credentials: AuthorizationCredentials(user: "other-client", password: "secret"))
        networkingService.completePendingRequest()

        wait(for: [authenticated], timeout: 2.0)

        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
        expect(self.credentialsManager.claims?.issuedFor).to(beNil())
    }

    // MARK: - Tests: concurrency

    func test_ParallelCalls_AllSucceedAndLeaveACacheableToken() {
        networkingService.responseDelay = 0.2

        let calls = 10
        let expectation = expectation(description: "all authenticated")
        expectation.expectedFulfillmentCount = calls

        DispatchQueue.concurrentPerform(iterations: calls) { _ in
            self.sut.authenticate { result in
                self.verify(result, is: .success)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0)

        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
        expect(self.credentialsManager.claims?.issuedFor).to(equal(Self.credentials))
    }

    func test_CompletionCallingAuthenticateAgain_DoesNotDeadlock() {
        let expectation = expectation(description: "re-entrant call completed")

        sut.authenticate { [sut] _ in
            sut.authenticate { _ in expectation.fulfill() }
        }

        waitForExpectations(timeout: 2.0)
    }

    func test_FailedRequest_FailsEveryCallerAndLeavesCacheEmpty() {
        networkingService.responseDelay = 0.2
        networkingService.error = MockError.failure

        let calls = 5
        let expectation = expectation(description: "all failed")
        expectation.expectedFulfillmentCount = calls

        DispatchQueue.concurrentPerform(iterations: calls) { _ in
            self.sut.authenticate { result in
                self.verify(result, is: .failure)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0)
        expect(self.credentialsManager.claims).to(beNil())
    }

    func test_FailedRequest_DoesNotBlockLaterCalls() {
        networkingService.error = MockError.failure
        authenticateAndWait(expecting: .failure)

        networkingService.error = nil
        authenticateAndWait()

        expect(self.credentialsManager.claims?.accessToken).to(equal(Self.accessToken))
        expect(self.networkingService.requestCount).to(equal(2))
    }

    // MARK: - Private

    private func authenticateAndWait(expecting outcome: Outcome = .success) {
        let expectation = expectation(description: "authenticated")

        sut.authenticate { result in
            self.verify(result, is: outcome)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }

    private func verify(_ result: Result<Void, Error>, is outcome: Outcome, file: StaticString = #filePath, line: UInt = #line) {
        switch (result, outcome) {
        case (.success, .success), (.failure, .failure):
            break
        case (.failure(let error), .success):
            XCTFail("Expected a success, got a failure: \(error)", file: file, line: line)
        case (.success, .failure):
            XCTFail("Expected a failure, got a success", file: file, line: line)
        }
    }

    private func store(claims: AuthorizationClaims) {
        credentialsManager.store(claims: claims)
    }

    private func makeCacheableClaims(expiringIn lifetime: TimeInterval) -> AuthorizationClaims {
        AuthorizationClaims(accessToken: "cached-token",
                            expiresAt: dateProvider.now.addingTimeInterval(lifetime),
                            issuedFor: Self.credentials)
    }
}

// MARK: - Constants

private extension DefaultAuthenticationService_Tests {

    static let accessToken = "fresh-token"
    static let credentials = AuthorizationCredentials(user: "client", password: "secret")
}

// MARK: - Test doubles

private extension DefaultAuthenticationService_Tests {

    enum Outcome {

        case success
        case failure
    }

    enum MockError: Error {

        case failure
    }

    struct MockDateProvider: DateProvider {

        // MARK: - Properties

        var now: Date
    }

    /// Answers asynchronously, like the real service — handlers are attached after `execute`.
    final class MockNetworkingService: NetworkingService {

        // MARK: - Properties

        var response = AuthorizationController.Authorize.Response(accessToken: DefaultAuthenticationService_Tests.accessToken, expiresIn: 7_200)
        var error: Error?
        var responseDelay: TimeInterval = 0.01

        /// Holds the response until `completePendingRequest()`, so a request is provably in flight.
        var holdsRequests = false
        var onRequestStarted: (() -> Void)?

        var requestCount: Int {
            lock.lock()
            defer { lock.unlock() }
            return _requestCount
        }

        private let lock = NSLock()
        private var _requestCount = 0
        private var pendingCompletion: (() -> Void)?

        // MARK: - API

        func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType {
            lock.lock()
            _requestCount += 1
            lock.unlock()

            let response = self.response
            let error = self.error
            let result = NetworkRequestResult<ResponseType>()

            let deliverResponse = {
                if let error {
                    result.handle(error: error)
                } else if let response = response as? ResponseType {
                    result.handle(success: response)
                }
            }

            guard holdsRequests else {
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + responseDelay, execute: deliverResponse)
                return result
            }

            lock.lock()
            pendingCompletion = deliverResponse
            lock.unlock()

            onRequestStarted?()

            return result
        }

        func completePendingRequest() {
            lock.lock()
            let completion = pendingCompletion
            pendingCompletion = nil
            lock.unlock()

            completion?()
        }
    }
}
