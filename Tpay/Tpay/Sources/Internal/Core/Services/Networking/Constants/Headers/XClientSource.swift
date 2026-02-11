//
//  Copyright © 2026 Tpay. All rights reserved.
//

struct XClientSource: HttpHeader {

    // MARK: - Properties

    let key = "X-Client-Source"
    var value: String {
        let platformPrefix = "tpay-" + compatibility.rawValue

        let version = switch compatibility {
        case .ios:
            SDKVersionProvider.currentVersion
        case .flutter, .reactNative:
            sdkVersionName ?? ""
        }

        let versionSuffix = version.isEmpty
        ? ""
        : ":" + version
        
        return "tpay-com/" + platformPrefix + versionSuffix
    }

    private let compatibility: Compatibility
    private let sdkVersionName: String?

    // MARK: - Lifecycle

    init(compatibility: Compatibility, sdkVersionName: String?) {
        self.compatibility = compatibility
        self.sdkVersionName = sdkVersionName
    }
}
