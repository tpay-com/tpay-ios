//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PayWithDigitalWalletViewModel: AnyObject {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    var isValid: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var digitalWallets: [Domain.PaymentMethod.DigitalWallet] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func select(digitalWallet: Domain.PaymentMethod.DigitalWallet)
    func invokePayment()
    
    func payWithApplePay(with token: Domain.ApplePayToken, then: @escaping (Result<Domain.OngoingTransaction, Error>) -> Void)
    func applePayFinished(with status: ApplePayStatus)
}
