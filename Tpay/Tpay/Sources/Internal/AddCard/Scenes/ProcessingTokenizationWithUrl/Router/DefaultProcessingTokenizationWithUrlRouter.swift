//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingTokenizationWithUrlRouter: ProcessingTokenizationWithUrlRouter {
    
    // MARK: - Events

    let onSuccess = Observable<Void>()
    let onError = Observable<Void>()
}
