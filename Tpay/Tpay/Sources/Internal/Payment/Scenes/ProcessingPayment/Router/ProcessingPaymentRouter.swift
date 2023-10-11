//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingPaymentRouter: AnyObject {
    
    // MARK: - Events
    
    var onSuccess: Observable<Void> { get }
    var onError: Observable<Void> { get }
}

extension ProcessingPaymentRouter {
    
    // MARK: - API
    
    func invokeOnSuccess() {
        onSuccess.on(.next(()))
    }
    
    func invokeOnError() {
        onError.on(.next(()))
    }
}
