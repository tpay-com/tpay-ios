//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingTokenizationWithUrlRouter: AnyObject {
    
    // MARK: - Events
    
    var onSuccess: Observable<Void> { get }
    var onError: Observable<Void> { get }
}

extension ProcessingTokenizationWithUrlRouter {

    // MARK: - API
    
    func invokeOnSuccess() {
        onSuccess.on(.next(()))
    }
    
    func invokeOnError() {
        onError.on(.next(()))
    }
}
