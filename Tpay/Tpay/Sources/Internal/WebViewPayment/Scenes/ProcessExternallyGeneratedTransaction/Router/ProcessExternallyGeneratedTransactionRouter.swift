//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol ProcessExternallyGeneratedTransactionRouter: AnyObject {
    
    // MARK: - Events
    
    var onSuccess: Observable<Void> { get }
    var onError: Observable<Void> { get }
}

extension ProcessExternallyGeneratedTransactionRouter {
    
    // MARK: - API

    func invokeOnSuccess() {
        onSuccess.on(.next(()))
    }
    
    func invokeOnError() {
        onError.on(.next(()))
    }
}
