//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation

enum DeviceAccessory {
    
    case camera
    case microphone
    
    var mediaType: AVMediaType {
        switch self {
        case .camera: return .video
        case .microphone: return .audio
        }
    }
    
}
