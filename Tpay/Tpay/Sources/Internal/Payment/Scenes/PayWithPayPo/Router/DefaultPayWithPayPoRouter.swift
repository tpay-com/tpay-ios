//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithPayPoRouter: PayWithPayPoRouter {
    
    // MARK: - Events
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onError = Observable<Error>()
}
