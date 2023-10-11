//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardRouter: AnyObject {
    
    // MARK: - Events
    
    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onCardScan: Observable<Void> { get }
    var onError: Observable<Error> { get }
    
    var onNavigateToOneClick: Observable<Void> { get }
}

extension PayWithCardRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnCardScan() {
        onCardScan.on(.next(()))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
    
    func invokeOnNavigateToOneClick() {
        onNavigateToOneClick.on(.next(()))
    }
}
