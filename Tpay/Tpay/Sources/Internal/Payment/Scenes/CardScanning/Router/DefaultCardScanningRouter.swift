//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultCardScanningRouter: CardScanningRouter {

    // MARK: - Events
    
    let closeAction = Observable<Void>()
    let completeAction = Observable<CardNumberDetectionModels.CreditCard>()
    
    // MARK: - API
    
    func close() {
        closeAction.on(.next(()))
    }
    
    func complete(with cardData: CardNumberDetectionModels.CreditCard) {
        completeAction.on(.next(cardData))
    }
}
