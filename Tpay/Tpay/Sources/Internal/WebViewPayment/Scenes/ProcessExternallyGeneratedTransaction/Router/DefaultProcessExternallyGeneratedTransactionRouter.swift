//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultProcessExternallyGeneratedTransactionRouter: ProcessExternallyGeneratedTransactionRouter {
    
    // MARK: - Events
    
    let onSuccess = Observable<Void>()
    let onError = Observable<Void>()
}
