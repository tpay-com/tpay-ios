//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultPayWithDigitalWalletsViewModel: PayWithDigitalWalletViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    let isValid = Observable<Bool>()
    
    // MARK: - Properties
    
    var digitalWallets: [Domain.PaymentMethod.DigitalWallet] { model.digitalWallets }
    var transaction: Domain.Transaction { model.transaction }
    
    private let model: PayWithDigitalWalletModel
    private let router: PayWithDigitalWalletRouter
    
    private var selectedDigitalWallet: Domain.PaymentMethod.DigitalWallet?
    
    // MARK: - Initializers
    
    init(model: PayWithDigitalWalletModel, router: PayWithDigitalWalletRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func select(digitalWallet: Domain.PaymentMethod.DigitalWallet) {
        selectedDigitalWallet = digitalWallet
        isValid.on(.next(true))
    }
    
    func invokePayment() {
        guard let selectedDigitalWallet = selectedDigitalWallet?.kind else {
            isValid.on(.next(false))
            return
        }
        
        startProcessing()
        
        switch selectedDigitalWallet {
        case .applePay:
            invokeApplePayPayment()
        default:
            break
        }
    }
    
    func payWithApplePay(with token: Domain.ApplePayToken, then: @escaping (Result<Domain.OngoingTransaction, Error>) -> Void) {
        model.payWithApplePay(with: token, then: then)
    }
    
    func applePayFinished(with status: ApplePayStatus) {
        stopProcessing()
        switch status {
        case .success(let transaction):
            router.invokeOnTransactionCreated(with: transaction)
        case .failure(let error):
            router.invokeOnError(with: error)
        default:
            break
        }
    }
    
    // MARK: - Private

    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func invokeApplePayPayment() {
        router.invokeOnApplePay()
    }
}
