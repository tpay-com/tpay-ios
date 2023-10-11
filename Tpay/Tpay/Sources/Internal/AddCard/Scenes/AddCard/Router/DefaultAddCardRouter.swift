//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultAddCardRouter: AddCardRouter {
    
    // MARK: - Events
    
    let onCardScan = Observable<Void>()
    let onSuccess = Observable<Domain.OngoingTokenization>()
    let onError = Observable<Error>()
    let closeAction = Observable<Void>()
    
    // MARK: - API
    
    func invokeOnCardScan() {
        onCardScan.on(.next(()))
    }
    
    func invokeOnSuccess(_ transaction: Domain.OngoingTokenization) {
        onSuccess.on(.next(transaction))
    }
    
    func invokeOnError(with error: Error) {
        onError.on(.next((error)))
    }
    
    func close() {
        closeAction.on(.next(()))
    }
}
