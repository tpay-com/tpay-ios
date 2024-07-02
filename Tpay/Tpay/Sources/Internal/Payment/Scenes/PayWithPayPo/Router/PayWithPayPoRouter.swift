//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol PayWithPayPoRouter: AnyObject {
    
    // MARK: - Events
    
    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onError: Observable<Error> { get }
}

extension PayWithPayPoRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }

    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
}
