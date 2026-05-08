//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

protocol NetworkingConfigurationProvider: AnyObject {

    // MARK: - Properties

    var configuration: NetworkingServiceConfiguration? { get }

    // MARK: - API

    /// Returns the current configuration if available, otherwise blocks the calling thread
    /// until either a configuration is stored or the timeout elapses.
    ///
    /// TPS-55: introduced to fix a race between `configure(merchant:)` and the first request
    /// (e.g. headless `getAvailablePaymentChannels()` during cold start). Previously
    /// `DefaultRequestFactory.request(for:)` called `preconditionFailure` when the
    /// configuration was nil, which caused EXC_BREAKPOINT crashes on `com.tpay.networking`.
    ///
    /// - Parameter timeout: maximum wait in seconds. Default 5s — covers realistic cold-start
    ///   delays without hanging the queue indefinitely if the integrator never calls `configure`.
    /// - Returns: the configuration, or `nil` if it was not stored before the timeout.
    func waitForConfiguration(timeout: TimeInterval) -> NetworkingServiceConfiguration?
}

extension NetworkingConfigurationProvider {

    /// Default no-wait implementation — returns whatever is currently stored. Concrete
    /// implementations that own the underlying storage (e.g. `DefaultNetworkingConfigurationManager`)
    /// override this with a real wait that broadcasts on `store(configuration:)`.
    func waitForConfiguration(timeout: TimeInterval) -> NetworkingServiceConfiguration? {
        configuration
    }
}
