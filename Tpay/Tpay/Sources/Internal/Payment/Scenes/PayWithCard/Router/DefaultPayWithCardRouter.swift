//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardRouter: PayWithCardRouter {
    
    // MARK: - Events
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onCardScan = Observable<Void>()
    let onError = Observable<Error>()
    let onNavigateToOneClick = Observable<Void>()
}
