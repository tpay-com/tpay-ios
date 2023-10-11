//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardTokenRouter: AnyObject {
    
    // MARK: - Events
    
    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onError: Observable<Error> { get }
    
    var onAddCardRequested: Observable<Void> { get }
}

extension PayWithCardTokenRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }

    func invokeOnAddCardRequested() {
        onAddCardRequested.on(.next(()))
    }
}
