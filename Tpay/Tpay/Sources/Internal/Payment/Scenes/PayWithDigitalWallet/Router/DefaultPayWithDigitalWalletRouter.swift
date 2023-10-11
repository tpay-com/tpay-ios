//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultPayWithDigitalWalletRouter: PayWithDigitalWalletRouter {
    
    // MARK: - Events
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onApplePay = Observable<Void>()
    let onError = Observable<Error>()
}
