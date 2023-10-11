//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikCodeRouter: PayWithBlikCodeRouter {
    
    // MARK: - Properties
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onError = Observable<Error>()
    let onNavigateToOneClick = Observable<Void>()
}
