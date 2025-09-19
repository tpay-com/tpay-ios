//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum UserApplication {
    
    case emailApp
    case bluetoothSettings
    case custom(String)
    
    var path: String {
        switch self {
        case .emailApp: return "message://"
        case .bluetoothSettings: return "App-prefs:root=Bluetooth"
        case let .custom(path): return path
        }
    }
    
}
