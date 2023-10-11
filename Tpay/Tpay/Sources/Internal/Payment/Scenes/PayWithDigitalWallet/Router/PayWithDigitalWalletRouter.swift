//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PayWithDigitalWalletRouter: AnyObject {
    
    // MARK: - Events
    
    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onApplePay: Observable<Void> { get }
    var onError: Observable<Error> { get }
}

extension PayWithDigitalWalletRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnApplePay() {
        onApplePay.on(.next(()))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
}
