//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultChoosePaymentMethodViewModel: ChoosePaymentMethodViewModel {
    
    // MARK: - Properties
    
    private(set) lazy var paymentMethods: Observable<[Domain.PaymentMethod]> = model.paymentMethods
    let initialPaymentMethod: Domain.PaymentMethod
    
    private let model: ChoosePaymentMethodModel
    private let router: ChoosePaymentMethodRouter
    
    private var selectedPaymentMethod: Domain.PaymentMethod?
    
    // MARK: - Initializers
    
    init(model: ChoosePaymentMethodModel, router: ChoosePaymentMethodRouter) {
        self.model = model
        self.router = router
        
        initialPaymentMethod = .digitalWallet(.any)
    }
    
    // MARK: - API
    
    func choose(method: Domain.PaymentMethod) {
        guard method != selectedPaymentMethod else { return }
        selectedPaymentMethod = method
        
        switch method {
        case .card: router.showCard()
        case .blik: router.showBLIK()
        case .pbl: router.showPBL()
        case .digitalWallet: router.showDigitalWallets()
        case .installmentPayments: router.showRatyPekao()
        case .unknown: break
        }
    }
    
    func getPaymentMethods() -> [Domain.PaymentMethod] {
        model.getPaymentMethods().sorted(by: \.order)
    }
}
