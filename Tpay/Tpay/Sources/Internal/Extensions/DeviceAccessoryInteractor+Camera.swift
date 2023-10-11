//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension DeviceAccessoryInteractor {
    
    func setupCameraAccessory(then: @escaping Completion) {
        if hasAccess(for: .camera) {
            then(.success(()))
            return
        }
        requestAccessForCamera(then: then)
    }
    
    private func requestAccessForCamera(then: @escaping Completion) {
        requestAccess(for: .camera, then: then)
    }
    
}
