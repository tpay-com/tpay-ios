//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

extension URL {
    var normalized: URL? {
        guard var components = normalizedComponents else {
            return nil
        }
        components.queryItems = queryItems
        return components.url
    }

    private var normalizedComponents: URLComponents? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let scheme = components.scheme,
              var host = components.host else {
            return nil
        }

        if host.hasPrefix(.wwwPrefix) {
            host.removePrefix(.wwwPrefix)
        }

        components.host = host
        components.scheme = scheme
        components.path = .slash

        return components
    }

    private var queryItems: [URLQueryItem]? {
        URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems
    }
}

private extension String {
    static let wwwPrefix = "www."
    static let slash = "/"

    mutating func removePrefix(_ prefix: String) {
        guard self.hasPrefix(prefix) else { return }
        self = String(self.dropFirst(prefix.count))
    }
}
