//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithAmbiguousBlikAliasesRouter: PayWithAmbiguousBlikAliasesRouter {
    
    // MARK: - Properties
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onNavigateToBlikCode = Observable<Void>()
    let onError = Observable<Error>()
}
