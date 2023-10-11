//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol SuccessRouter: AnyObject {
    
    // MARK: - Events
    
    var onProceed: Observable<Void> { get }
}

extension SuccessRouter {
    
    // MARK: - API

    func invokeOnProceed() {
        onProceed.on(.next(()))
    }
}
