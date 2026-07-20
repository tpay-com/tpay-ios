//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultChoosePaymentMethodViewModel: ChoosePaymentMethodViewModel {
    
    // MARK: - Properties
    
    private(set) lazy var paymentMethods: Observable<[Domain.PaymentMethod]> = model.paymentMethods
    let initialPaymentMethod: Domain.PaymentMethod
    
    private let model: ChoosePaymentMethodModel
    private let router: ChoosePaymentMethodRouter
    private let transactionLock: SingleTransactionLock

    private var selectedPaymentMethod: Domain.PaymentMethod?
    
    // MARK: - Initializers

    init(model: ChoosePaymentMethodModel, router: ChoosePaymentMethodRouter, transactionLock: SingleTransactionLock) {
        self.model = model
        self.router = router
        self.transactionLock = transactionLock

        initialPaymentMethod = transactionLock.paymentMethod ?? .digitalWallet(.any)
    }
    
    // MARK: - API
    
    func choose(method: Domain.PaymentMethod) {
        guard method != selectedPaymentMethod else { return }
        if let lockedPaymentMethod = transactionLock.paymentMethod, method != lockedPaymentMethod {
            router.notifyPaymentMethodChangeBlocked()
            return
        }
        selectedPaymentMethod = method
        
        switch method {
        case .card: router.showCard()
        case .blik: router.showBLIK()
        case .pbl: router.showPBL()
        case .digitalWallet: router.showDigitalWallets()
        case .installmentPayments: router.showRatyPekao()
        case .payPo: router.showPayPo()
        case .unknown: break
        }
    }
    
    func getPaymentMethods() -> [Domain.PaymentMethod] {
        model.getPaymentMethods().sorted(by: \.order)
    }

    func isSelectable(_ method: Domain.PaymentMethod) -> Bool {
        guard let lockedPaymentMethod = transactionLock.paymentMethod else { return true }
        return method == lockedPaymentMethod
    }
}
