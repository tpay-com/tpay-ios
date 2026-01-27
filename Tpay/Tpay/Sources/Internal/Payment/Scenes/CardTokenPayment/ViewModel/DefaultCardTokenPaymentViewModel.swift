//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultCardTokenPaymentViewModel: CardTokenPaymentViewModel {
    
    // MARK: - Properties
    
    let title: String
    let message: String
    
    private let model: CardTokenPaymentModel
    private let router: CardTokenPaymentRouter
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(title: String, message: String, model: CardTokenPaymentModel, router: CardTokenPaymentRouter) {
        self.title = title
        self.message = message
        self.model = model
        self.router = router
        
        observeEvents()
    }
    
    // MARK: - API
    
    func invokePayment() {
        model.invokePayment()
    }
    
    // MARK: - Private
    
    private func observeEvents() {
        model.onPaymentCompleted
            .subscribe(onNext: { [weak self] transactionId in self?.router.invokeOnPaymentCompleted(transactionId: transactionId) })
            .add(to: disposer)
        
        model.onPaymentFailed
            .subscribe(onNext: { [weak self] transactionId in self?.router.invokeOnPaymentFailed(transactionId: transactionId) })
            .add(to: disposer)
        
        model.errorOcured
            .subscribe(onNext: { [weak self] error in self?.router.invokeOnError(error) })
            .add(to: disposer)
        
        model.transactionWithUrlOccured
            .subscribe(onNext: { [weak self] ongoingTransaction in self?.router.invokeOnTransactionUrl(ongoingTransaction: ongoingTransaction) })
            .add(to: disposer)
    }
}
