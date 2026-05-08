//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

final class DefaultNetworkingConfigurationManager: NetworkingConfigurationManager {

    // MARK: - Properties

    /// Coordinates `store(configuration:)` (broadcast) with `waitForConfiguration(timeout:)` (wait).
    /// `NSCondition` is used because:
    /// - reads/writes of `_configuration` must be locked (race-free)
    /// - multiple threads may concurrently `wait` and must all wake on a single `store`
    /// - `broadcast()` wakes every waiter; signal would only wake one
    private let condition = NSCondition()
    private var _configuration: NetworkingServiceConfiguration?

    // MARK: - API

    var configuration: NetworkingServiceConfiguration? {
        condition.lock()
        defer { condition.unlock() }
        return _configuration
    }

    func store(configuration: NetworkingServiceConfiguration) {
        condition.lock()
        _configuration = configuration
        condition.broadcast()
        condition.unlock()
    }

    func remove() {
        condition.lock()
        _configuration = nil
        condition.unlock()
    }

    func waitForConfiguration(timeout: TimeInterval) -> NetworkingServiceConfiguration? {
        condition.lock()
        defer { condition.unlock() }

        if _configuration != nil {
            return _configuration
        }

        let deadline = Date().addingTimeInterval(timeout)
        // `NSCondition.wait(until:)` may wake spuriously, so loop until either the
        // configuration is set or the deadline passes.
        while _configuration == nil && Date() < deadline {
            _ = condition.wait(until: deadline)
        }

        return _configuration
    }
}
