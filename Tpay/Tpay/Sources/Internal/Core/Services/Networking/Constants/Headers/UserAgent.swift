//
//  Copyright © 2026 Tpay. All rights reserved.
//

struct UserAgent: HttpHeader {

    // MARK: - Properties

    let key = "User-Agent"
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
        
        return platformPrefix + versionSuffix + "|" + DeviceInfoProvider.userAgentDeviceInfo
    }

    private let compatibility: Compatibility
    private let sdkVersionName: String?

    // MARK: - Lifecycle

    init(compatibility: Compatibility, sdkVersionName: String?) {
        self.compatibility = compatibility
        self.sdkVersionName = sdkVersionName
    }
}
