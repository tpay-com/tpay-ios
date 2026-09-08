//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class AuthenticatingNetworkingService_Tests: XCTestCase {

    // MARK: - Properties

    private let networkingService = MockNetworkingService()
    private let credentialsManager = DefaultCredentialsManager()
    private lazy var authenticationService = MockAuthenticationService(credentialsProvider: credentialsManager)

    private lazy var sut = AuthenticatingNetworkingService(decorating: networkingService,
                                                           credentialsStore: credentialsManager,
                                                           credentialsProvider: credentialsManager,
                                                           authenticationServiceFactory: { [unowned self] in self.authenticationService })

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        credentialsManager.store(claims: AuthorizationClaims(accessToken: "rejected-token"))
    }

    // MARK: - Tests

    func test_UnauthorizedBearerRequest_IsRetriedWithARefreshedToken() {
        networkingService.outcomes = [.failure(Self.unauthorized), .success(())]

        expect(self.execute(.bearer)).to(beTrue())

        expect(self.networkingService.requestCount).to(equal(2))
        expect(self.authenticationService.callCount).to(equal(1))
        expect(self.authenticationService.claimsWhenCalled).to(beNil())
    }

    func test_UnauthorizedRetry_IsNotRetriedAgain() {
        networkingService.outcomes = [.failure(Self.unauthorized), .failure(Self.unauthorized)]

        expect(self.execute(.bearer)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(2))
        expect(self.authenticationService.callCount).to(equal(1))
    }

    func test_UnauthorizedBasicRequest_IsNotRetried() {
        networkingService.outcomes = [.failure(Self.unauthorized)]

        expect(self.execute(.basic)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(1))
        expect(self.authenticationService.callCount).to(equal(0))
    }

    func test_OtherServerError_IsNotRetried() {
        let serverError = NetworkingError.serverError(ServerError(httpStatusCode: .internalServerError, errors: ServiceErrors(errors: [])))
        networkingService.outcomes = [.failure(serverError)]

        expect(self.execute(.bearer)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(1))
        expect(self.authenticationService.callCount).to(equal(0))
    }

    func test_SuccessfulRequest_IsPassedThrough() {
        networkingService.outcomes = [.success(())]

        expect(self.execute(.bearer)).to(beTrue())

        expect(self.networkingService.requestCount).to(equal(1))
        expect(self.authenticationService.callCount).to(equal(0))
    }

    func test_FailedRefresh_StopsTheRetry() {
        networkingService.outcomes = [.failure(Self.unauthorized)]
        authenticationService.result = .failure(MockError.refreshFailed)

        expect(self.execute(.bearer)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(1))
        expect(self.authenticationService.callCount).to(equal(1))
    }

    // MARK: - Tests: authentication before the request

    func test_BearerRequest_IsAuthenticatedBeforeItIsSent() {
        credentialsManager.store(credentials: Self.credentials)
        networkingService.outcomes = [.success(())]

        var requestCountWhenAuthenticated: Int?
        authenticationService.onAuthenticate = { [unowned self] in requestCountWhenAuthenticated = self.networkingService.requestCount }

        expect(self.execute(.bearer)).to(beTrue())

        expect(self.authenticationService.callCount).to(equal(1))
        expect(self.networkingService.requestCount).to(equal(1))
        expect(requestCountWhenAuthenticated).to(equal(0))
    }

    func test_BasicRequest_IsNotAuthenticatedUpfront() {
        credentialsManager.store(credentials: Self.credentials)
        networkingService.outcomes = [.success(())]

        expect(self.execute(.basic)).to(beTrue())

        expect(self.authenticationService.callCount).to(equal(0))
    }

    func test_RequestWithoutCredentials_IsNotAuthenticatedUpfront() {
        networkingService.outcomes = [.success(())]

        expect(self.execute(.bearer)).to(beTrue())

        expect(self.authenticationService.callCount).to(equal(0))
        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_FailedAuthenticationWithATokenOfTheSameMerchant_StillSendsTheRequest() {
        credentialsManager.store(credentials: Self.credentials)
        credentialsManager.store(claims: Self.claims(issuedFor: Self.credentials))
        authenticationService.result = .failure(MockError.refreshFailed)
        networkingService.outcomes = [.success(())]

        expect(self.execute(.bearer)).to(beTrue())

        expect(self.networkingService.requestCount).to(equal(1))
    }

    func test_FailedAuthenticationWithATokenOfAnotherMerchant_FailsTheRequest() {
        credentialsManager.store(credentials: Self.credentials)
        credentialsManager.store(claims: Self.claims(issuedFor: Self.otherMerchantCredentials))
        authenticationService.result = .failure(MockError.refreshFailed)

        expect(self.execute(.bearer)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(0))
    }

    func test_FailedAuthenticationWithoutAToken_FailsTheRequest() {
        credentialsManager.store(credentials: Self.credentials)
        credentialsManager.removeClaims()
        authenticationService.result = .failure(MockError.refreshFailed)

        expect(self.execute(.bearer)).to(beFalse())

        expect(self.networkingService.requestCount).to(equal(0))
    }

    // MARK: - Tests: cancellation

    func test_CancellingTheResult_CancelsTheOngoingRequest() {
        networkingService.outcomes = []

        let result = sut.execute(request: StubRequest(authorization: .bearer))
        result.cancelTask()

        expect(self.networkingService.lastTask?.isCancelled).to(equal(true))
    }

    // MARK: - Private

    private func execute(_ authorization: Authorization) -> Bool {
        let expectation = expectation(description: "request completed")
        var succeeded = false

        sut.execute(request: StubRequest(authorization: authorization))
            .onResult { result in
                succeeded = (try? result.get()) != nil
                expectation.fulfill()
            }

        waitForExpectations(timeout: 2.0)
        return succeeded
    }
}

// MARK: - Constants

private extension AuthenticatingNetworkingService_Tests {

    static let unauthorized = NetworkingError.serverError(ServerError(httpStatusCode: .unauthorized, errors: ServiceErrors(errors: [])))
    static let credentials = AuthorizationCredentials(user: "client", password: "secret")
    static let otherMerchantCredentials = AuthorizationCredentials(user: "other-client", password: "secret")

    static func claims(issuedFor credentials: AuthorizationCredentials) -> AuthorizationClaims {
        AuthorizationClaims(accessToken: "cached-token", expiresAt: Date().addingTimeInterval(7_200), issuedFor: credentials)
    }
}

// MARK: - Test doubles

private extension AuthenticatingNetworkingService_Tests {

    enum MockError: Error {

        case refreshFailed
    }

    struct StubResponse: Decodable { }

    struct StubRequest: NetworkRequest {

        typealias ResponseType = StubResponse

        // MARK: - Properties

        let resource: NetworkResource

        // MARK: - Initializers

        init(authorization: Authorization) {
            resource = NetworkResource(url: URL(staticString: "/stub"), method: .get, authorization: authorization)
        }

        // MARK: - API

        func encode(to encoder: Encoder) throws { }
    }

    final class StubNetworkTask: NetworkTask {

        // MARK: - Properties

        private(set) var isCancelled = false

        // MARK: - API

        func cancel() {
            isCancelled = true
        }
    }

    /// Requests beyond the configured outcomes stay in flight — needed by the cancellation test.
    final class MockNetworkingService: NetworkingService {

        // MARK: - Properties

        var outcomes: [Result<Void, Error>] = []

        /// Locked — a retry runs on the authentication service's queue.
        var requestCount: Int {
            lock.lock()
            defer { lock.unlock() }
            return _requestCount
        }

        var lastTask: StubNetworkTask? {
            lock.lock()
            defer { lock.unlock() }
            return _lastTask
        }

        private let lock = NSLock()
        private var _requestCount = 0
        private var _lastTask: StubNetworkTask?

        /// Kept alive here, the way `URLSession` keeps them in production.
        private var tasks: [StubNetworkTask] = []
        private var results: [AnyObject] = []

        // MARK: - API

        func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType {
            let result = NetworkRequestResult<ResponseType>()
            let task = StubNetworkTask()
            result.networkTask = task

            lock.lock()
            let outcome: Result<Void, Error>? = _requestCount < outcomes.count ? outcomes[_requestCount] : nil
            _requestCount += 1
            _lastTask = task
            tasks.append(task)
            results.append(result)
            lock.unlock()

            guard let outcome else { return result }

            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.01) {
                switch outcome {
                case .success:
                    if let response = StubResponse() as? ResponseType {
                        result.handle(success: response)
                    }
                case .failure(let error):
                    result.handle(error: error)
                }
            }

            return result
        }
    }

    final class MockAuthenticationService: AuthenticationService {

        // MARK: - Properties

        var result: Result<Void, Error> = .success(())
        var onAuthenticate: (() -> Void)?

        private(set) var callCount = 0

        private(set) var claimsWhenCalled: AuthorizationClaims?

        private let credentialsProvider: CredentialsProvider

        // MARK: - Initializers

        init(credentialsProvider: CredentialsProvider) {
            self.credentialsProvider = credentialsProvider
        }

        // MARK: - API

        /// Answers asynchronously, like the real service — handlers are attached after `execute`.
        func authenticate(then: @escaping Completion) {
            callCount += 1
            claimsWhenCalled = credentialsProvider.claims
            onAuthenticate?()

            let result = self.result
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.01) { then(result) }
        }
    }
}
