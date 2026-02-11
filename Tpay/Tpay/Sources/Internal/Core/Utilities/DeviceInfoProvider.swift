//
//  Copyright © 2026 Tpay. All rights reserved.
//

import UIKit

enum DeviceInfoProvider {

    // MARK: - Properties

    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        return modelCode ?? "Unknown"
    }

    static var osVersion: String {
        let systemVersion = UIDevice.current.systemVersion
        return "iOS " + systemVersion
    }

    static var userAgentDeviceInfo: String {
        deviceModel + "|" + osVersion
    }
}
