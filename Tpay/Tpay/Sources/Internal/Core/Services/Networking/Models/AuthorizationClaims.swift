//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

struct AuthorizationClaims {

    // MARK: - Properties

    let accessToken: String

    /// `nil` in either property means the token is used for requests, but never cached.
    let expiresAt: Date?
    let issuedFor: AuthorizationCredentials?

    // MARK: - Initializers

    init(
        accessToken: String,
        expiresAt: Date? = nil,
        issuedFor: AuthorizationCredentials? = nil
    ) {
        self.accessToken = accessToken
        self.expiresAt = expiresAt
        self.issuedFor = issuedFor
    }
}

extension AuthorizationClaims {

    // MARK: - Static properties

    static let refreshMargin: TimeInterval = 100

    // MARK: - API

    func isValid(
        at date: Date,
        for credentials: AuthorizationCredentials
    ) -> Bool {
        guard
            let expiresAt,
            let issuedFor,
            issuedFor == credentials
        else {
            return false
        }

        return date.addingTimeInterval(Self.refreshMargin) < expiresAt
    }
}
