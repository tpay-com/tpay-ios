//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardTokenRouter: PayWithCardTokenRouter {
    
    // MARK: - Events

    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onError = Observable<Error>()
    let onAddCardRequested = Observable<Void>()
}
