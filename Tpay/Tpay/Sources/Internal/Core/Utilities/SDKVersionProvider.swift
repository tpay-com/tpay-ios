//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation

enum SDKVersionProvider {

    // MARK: - Properties

    static var currentVersion: String {
        if let bundleVersion = frameworkBundleVersion {
            return bundleVersion
        }

        return fallbackVersion
    }

    // MARK: - Private

    private static var frameworkBundleVersion: String? {
        if let bundle = Bundle(identifier: "com.tpay.Tpay") ?? Bundle(identifier: "org.cocoapods.Tpay") {
            if let version = bundle.version {
                return version
            }
        }

        return nil
    }

    /// Fallback version from podspec - updated during release process
    private static let fallbackVersion = "1.3.10"
}

// MARK: - Bundle Token

/// Token class used to identify the Tpay framework bundle
private final class BundleToken { }

private extension Bundle {
    var version: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
        ?? infoDictionary?["CFBundleVersion"] as? String
    }
}
