//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayByLinkRouter: AnyObject {
    
    // MARK: - Events

    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onError: Observable<Error> { get }
}

extension PayByLinkRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
}
