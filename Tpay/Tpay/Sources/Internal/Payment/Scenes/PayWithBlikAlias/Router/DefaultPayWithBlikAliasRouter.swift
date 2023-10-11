//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Combine

final class DefaultPayWithBlikAliasRouter: PayWithBlikAliasRouter {

    // MARK: - Properties
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onNavigateToBlikCode = Observable<Void>()
    let onError = Observable<Error>()
}
