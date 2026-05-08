//
//  Copyright © 2026 Tpay. All rights reserved.
//

@testable import Tpay
import XCTest

/// Tests for TPS-55: race condition between `configure(merchant:)` and the first network
/// request (typically headless `getAvailablePaymentChannels()` during cold start).
///
/// Before the fix, `DefaultRequestFactory.request(for:)` called `preconditionFailure`
/// when `configurationProvider.configuration` was nil — this raised SIGTRAP / EXC_BREAKPOINT
/// on the `com.tpay.networking` serial queue and crashed the host app.
///
/// After the fix:
/// - `DefaultNetworkingConfigurationManager` exposes a wait-and-broadcast mechanism via
///   `NSCondition`. `store(configuration:)` broadcasts; `waitForConfiguration(timeout:)` blocks.
/// - `DefaultRequestFactory.request(for:)` is `throws -> URLRequest`. It waits for up to
///   `configurationWaitTimeout` (default 5s) for a configuration; if still missing, throws
///   `NetworkingError.notConfigured`.
/// - `DefaultNetworkingService.execute(request:for:)` catches the throw and routes the error
///   through `result.handle(error:)` so the caller receives a typed failure instead of a crash.
final class NetworkingConfigurationRace_Tests: XCTestCase {

    // MARK: - DefaultNetworkingConfigurationManager.waitForConfiguration

    /// `waitForConfiguration` returns immediately when the configuration is already present —
    /// no `NSCondition.wait` should be entered. Verifies the fast-path (happy case).
    func test_WaitForConfiguration_ReturnsImmediatelyIfAlreadySet() {
        let manager = DefaultNetworkingConfigurationManager()
        manager.store(configuration: Stub.config)

        let start = Date()
        let result = manager.waitForConfiguration(timeout: 5.0)
        let elapsed = Date().timeIntervalSince(start)

        XCTAssertNotNil(result)
        XCTAssertLessThan(elapsed, 0.05, "fast-path must not enter the condition wait")
    }

    /// Reproduces the production race: a request waits for configuration, configuration arrives
    /// 100ms later via `store(configuration:)` from another thread, the wait returns successfully.
    /// Without `NSCondition.broadcast`, the wait would never wake up.
    func test_WaitForConfiguration_BlocksUntilConfigured() {
        let manager = DefaultNetworkingConfigurationManager()
        let didReturn = expectation(description: "wait returned with configuration")

        DispatchQueue.global(qos: .userInitiated).async {
            let result = manager.waitForConfiguration(timeout: 5.0)
            XCTAssertNotNil(result)
            didReturn.fulfill()
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            manager.store(configuration: Stub.config)
        }

        wait(for: [didReturn], timeout: 2.0)
    }

    /// Integration bug: integrator never calls `configure`. Wait must time out and return nil
    /// (caller will translate to `NetworkingError.notConfigured`) instead of hanging forever.
    func test_WaitForConfiguration_TimesOutWhenNeverConfigured() {
        let manager = DefaultNetworkingConfigurationManager()

        let start = Date()
        let result = manager.waitForConfiguration(timeout: 0.5)
        let elapsed = Date().timeIntervalSince(start)

        XCTAssertNil(result)
        XCTAssertGreaterThanOrEqual(elapsed, 0.5, "must wait the full timeout")
        XCTAssertLessThan(elapsed, 1.5, "must not significantly overshoot the timeout")
    }

    /// Multiple concurrent waiters must all wake on a single `store` — verifies that
    /// `NSCondition.broadcast()` (not `signal()`) is used.
    func test_WaitForConfiguration_BroadcastsToMultipleWaiters() {
        let manager = DefaultNetworkingConfigurationManager()
        let waiterCount = 50
        let allWoke = expectation(description: "all waiters woke")
        allWoke.expectedFulfillmentCount = waiterCount

        for _ in 0..<waiterCount {
            DispatchQueue.global().async {
                if manager.waitForConfiguration(timeout: 3.0) != nil {
                    allWoke.fulfill()
                }
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            manager.store(configuration: Stub.config)
        }

        wait(for: [allWoke], timeout: 5.0)
    }

    /// Late waiter (started after `store`) returns immediately via fast-path.
    func test_WaitForConfiguration_LateWaiterAfterStore_ReturnsImmediately() {
        let manager = DefaultNetworkingConfigurationManager()
        manager.store(configuration: Stub.config)

        let start = Date()
        let result = manager.waitForConfiguration(timeout: 5.0)
        let elapsed = Date().timeIntervalSince(start)

        XCTAssertNotNil(result)
        XCTAssertLessThan(elapsed, 0.05)
    }

    // MARK: - Data race / concurrent access stress tests

    /// Stress test: many concurrent stores, reads, waits, and removes. Verifies NSCondition
    /// locking is correct — no crash, no use-after-free, no missed signals.
    func test_ConcurrentStoreReadWait_NoCrash() {
        let manager = DefaultNetworkingConfigurationManager()
        let iterations = 500
        let group = DispatchGroup()

        for i in 0..<iterations {
            // Writer
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                manager.store(configuration: NetworkingServiceConfiguration(scheme: "https", host: "host\(i).test", port: nil))
                group.leave()
            }

            // Reader (property access)
            group.enter()
            DispatchQueue.global(qos: .background).async {
                _ = manager.configuration
                group.leave()
            }

            // Waiter (every 10th iteration to keep test bounded)
            if i.isMultiple(of: 10) {
                group.enter()
                DispatchQueue.global().async {
                    _ = manager.waitForConfiguration(timeout: 0.05)
                    group.leave()
                }
            }
        }

        let result = group.wait(timeout: .now() + 15.0)
        XCTAssertEqual(result, .success, "concurrent operations must not deadlock or crash")
    }

    /// `remove()` followed by a wait should time out — `remove` does not broadcast, and any
    /// previously stored configuration was cleared.
    func test_RemoveThenWait_TimesOut() {
        let manager = DefaultNetworkingConfigurationManager()
        manager.store(configuration: Stub.config)
        XCTAssertNotNil(manager.configuration)

        manager.remove()
        XCTAssertNil(manager.configuration)

        let result = manager.waitForConfiguration(timeout: 0.3)
        XCTAssertNil(result, "remove() should leave wait to time out")
    }

    /// Reconfiguration: store, remove, store again — second store must rebroadcast and wake waiters.
    func test_StoreRemoveStore_SecondStoreWakesWaiters() {
        let manager = DefaultNetworkingConfigurationManager()
        manager.store(configuration: Stub.config)
        manager.remove()

        let didReturn = expectation(description: "wait returned with new configuration")

        DispatchQueue.global().async {
            let result = manager.waitForConfiguration(timeout: 2.0)
            XCTAssertNotNil(result)
            didReturn.fulfill()
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            manager.store(configuration: Stub.config)
        }

        wait(for: [didReturn], timeout: 3.0)
    }

    // MARK: - DefaultRequestFactory + DefaultNetworkingService integration

    /// Production crash signature TPS-55: `getAvailablePaymentChannels()` called before
    /// `configure(merchant:)`. With the fix, the request fails with `NetworkingError.notConfigured`
    /// instead of crashing the app.
    func test_RequestFactory_ThrowsNotConfigured_AfterTimeout() {
        let manager = DefaultNetworkingConfigurationManager()  // never stored
        let factory = DefaultRequestFactory(
            networkingConfigurationProvider: manager,
            headersProvider: StubHeadersProvider(),
            queryEncoder: StubQueryEncoder(),
            bodyEncoder: StubBodyEncoder(),
            configurationWaitTimeout: 0.2
        )

        XCTAssertThrowsError(try factory.request(for: Stub.networkRequest)) { error in
            guard case NetworkingError.notConfigured = error else {
                XCTFail("expected NetworkingError.notConfigured, got \(error)")
                return
            }
        }
    }

    /// Cold-start race: request started before `configure`, configuration arrives during the wait.
    /// Request must succeed (URLRequest constructed) — the fix's primary purpose.
    func test_RequestFactory_SucceedsWhenConfigArrivesWithinTimeout() throws {
        let manager = DefaultNetworkingConfigurationManager()
        let factory = DefaultRequestFactory(
            networkingConfigurationProvider: manager,
            headersProvider: StubHeadersProvider(),
            queryEncoder: StubQueryEncoder(),
            bodyEncoder: StubBodyEncoder(),
            configurationWaitTimeout: 5.0
        )

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            manager.store(configuration: Stub.config)
        }

        let urlRequest = try factory.request(for: Stub.networkRequest)
        XCTAssertEqual(urlRequest.url?.host, "api.tpay.com")
    }

    /// `LocalizedError` conformance gives integrators a human-readable message rather than
    /// just the enum case name. Tested because the RN bridge serializes errors via `"\(error)"` —
    /// without `errorDescription`, the React Native client would see a cryptic `notConfigured`.
    func test_NotConfiguredError_HasHumanReadableDescription() {
        let error: Error = NetworkingError.notConfigured
        let description = (error as? LocalizedError)?.errorDescription ?? "\(error)"

        XCTAssertTrue(description.contains("not configured"), "description: \(description)")
        XCTAssertTrue(description.contains("configure"), "description should hint at the fix: \(description)")
    }
}

// MARK: - Test Doubles

private extension NetworkingConfigurationRace_Tests {

    enum Stub {
        static let config = NetworkingServiceConfiguration(scheme: "https", host: "api.tpay.com", port: nil)

        static let networkRequest: AuthorizationController.Authorize = AuthorizationController.Authorize()
    }

    final class StubHeadersProvider: HttpHeadersProvider {
        func headers(for resource: NetworkResource) -> [HttpHeader] { [] }
    }

    final class StubQueryEncoder: QueryEncoder {
        func queryItems<ObjectType: Encodable>(from object: ObjectType) -> [URLQueryItem]? { nil }
    }

    final class StubBodyEncoder: BodyEncoder {
        func body<ObjectType: Encodable>(from object: ObjectType, for resource: NetworkResource) -> Data? { nil }
    }
}
