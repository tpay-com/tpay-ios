//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation

final class DefaultDeviceAccessoryInteractor: DeviceAccessoryInteractor {
    
    // MARK: - Initializers
    
    init() { }
    
    // MARK: - API
    
    func hasAccess(for deviceAccessory: DeviceAccessory) -> Bool {
        AVCaptureDevice.authorizationStatus(for: deviceAccessory.mediaType) == .authorized
    }
    
    func requestAccess(for deviceAccessory: DeviceAccessory, then: @escaping (Result<Void, Error>) -> Void) {
        AVCaptureDevice.requestAccess(for: deviceAccessory.mediaType) { isAccessGranted in
            guard isAccessGranted else {
                DispatchQueue.main.async { then(.failure(DeviceAccessoryInteractorError.accessNotGranted)) }
                return
            }
            DispatchQueue.main.async { then(.success(())) }
        }
    }
    
}
