//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension AuthorizationController.Authorize {

    struct Response {

        // MARK: - Properties

        let accessToken: String
        let expiresIn: TimeInterval?
    }
}

extension AuthorizationController.Authorize.Response: Decodable {

    enum CodingKeys: String, CodingKey {

        // MARK: - Cases

        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = Self.decodeExpiresIn(from: container)
    }

    // MARK: - Private

    /// `expires_in` only enables caching, so any unexpected shape yields `nil` instead of
    /// failing the whole response.
    private static func decodeExpiresIn(from container: KeyedDecodingContainer<CodingKeys>) -> TimeInterval? {
        if let seconds = try? container.decode(TimeInterval.self, forKey: .expiresIn) {
            return seconds
        }
        if let text = try? container.decode(String.self, forKey: .expiresIn) {
            return TimeInterval(text)
        }
        return nil
    }
}
