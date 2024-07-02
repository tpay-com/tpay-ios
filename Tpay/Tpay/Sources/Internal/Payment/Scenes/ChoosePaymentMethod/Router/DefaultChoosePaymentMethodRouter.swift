//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultChoosePaymentMethodRouter: ChoosePaymentMethodRouter {
    
    // MARK: - Events
    
    let showCardFlow: Observable<Void> = Observable<Void>()
    let showBLIKFlow: Observable<Void> = Observable<Void>()
    let showPBLFlow: Observable<Void> = Observable<Void>()
    let showDigitalWalletsFlow: Observable<Void> = Observable<Void>()
    let showRatyPekaoFlow: Observable<Void> = Observable<Void>()
    let showPayPoFlow: Observable<Void> = Observable<Void>()
    
    // MARK: - API

    func showCard() {
        showCardFlow.on(.next(()))
    }
    
    func showBLIK() {
        showBLIKFlow.on(.next(()))
    }
    
    func showPBL() {
        showPBLFlow.on(.next(()))
    }
    
    func showDigitalWallets() {
        showDigitalWalletsFlow.on(.next(()))
    }
    
    func showRatyPekao() {
        showRatyPekaoFlow.on(.next(()))
    }
    
    func showPayPo() {
        showPayPoFlow.on(.next(()))
    }
}
