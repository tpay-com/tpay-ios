//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayByLinkRouter: PayByLinkRouter {
    
    // MARK: - Properties
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onError = Observable<Error>()
}
