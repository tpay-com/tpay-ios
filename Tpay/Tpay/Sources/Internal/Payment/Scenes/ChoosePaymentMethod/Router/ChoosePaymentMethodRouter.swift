//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ChoosePaymentMethodRouter: AnyObject {
    
    // MARK: - Events
    
    var showCardFlow: Observable<Void> { get }
    var showBLIKFlow: Observable<Void> { get }
    var showPBLFlow: Observable<Void> { get }
    var showDigitalWalletsFlow: Observable<Void> { get }
    var showRatyPekaoFlow: Observable<Void> { get }
    var showPayPoFlow: Observable<Void> { get }
    
    // MARK: - Methods
    
    func showCard()
    func showBLIK()
    func showPBL()
    func showDigitalWallets()
    func showRatyPekao()
    func showPayPo()
}
