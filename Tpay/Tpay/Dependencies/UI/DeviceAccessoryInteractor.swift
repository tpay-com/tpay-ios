//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol DeviceAccessoryInteractor: AnyObject {
    
    func hasAccess(for: DeviceAccessory) -> Bool

    func requestAccess(for: DeviceAccessory, then: @escaping (Result<Void, Error>) -> Void)
    
}
