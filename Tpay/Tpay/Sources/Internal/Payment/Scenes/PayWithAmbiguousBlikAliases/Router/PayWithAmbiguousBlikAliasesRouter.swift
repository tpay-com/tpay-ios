//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithAmbiguousBlikAliasesRouter: AnyObject {
    
    // MARK: - Events

    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onNavigateToBlikCode: Observable<Void> { get }
    var onError: Observable<Error> { get }
}

extension PayWithAmbiguousBlikAliasesRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnNavigateToBlikCode() {
        onNavigateToBlikCode.on(.next(()))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
}
