//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultCredentialsManager: CredentialsManager {

    // MARK: - Properties

    /// Written from the host thread and `com.tpay.authentication`, read while building headers
    /// on `com.tpay.networking`.
    private let lock = NSLock()

    private var _claims: AuthorizationClaims?
    private var _credentials: AuthorizationCredentials?

    // MARK: - API

    var claims: AuthorizationClaims? {
        lock.lock()
        defer { lock.unlock() }
        return _claims
    }

    var credentials: AuthorizationCredentials? {
        lock.lock()
        defer { lock.unlock() }
        return _credentials
    }

    func store(claims: AuthorizationClaims) {
        lock.lock()
        defer { lock.unlock() }
        _claims = claims
    }

    func store(credentials: AuthorizationCredentials) {
        lock.lock()
        defer { lock.unlock() }
        _credentials = credentials
    }

    func removeClaims() {
        lock.lock()
        defer { lock.unlock() }
        _claims = nil
    }

    func removeCredentials() {
        lock.lock()
        defer { lock.unlock() }
        _credentials = nil
    }
}
