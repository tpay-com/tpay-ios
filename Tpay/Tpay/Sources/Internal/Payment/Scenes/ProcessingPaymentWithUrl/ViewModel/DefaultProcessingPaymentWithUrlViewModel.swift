//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingPaymentWithUrlViewModel: ProcessingPaymentWithUrlViewModel {
    
    // MARK: - Properties
    
    var continueUrl: URL { model.continueUrl }
    var successUrl: URL { model.successUrl }
    var errorUrl: URL { model.errorUrl }
    
    private let model: ProcessingPaymentWithUrlModel
    private let router: ProcessingPaymentWithUrlRouter
    
    private let disposer = Disposer()
    
    // MARK: - Initializers

    init(model: ProcessingPaymentWithUrlModel, router: ProcessingPaymentWithUrlRouter) {
        self.model = model
        self.router = router
        
        startObserving()
    }
    
    // MARK: - API
    
    func completeWithSuccess() {
        router.invokeOnSuccess()
    }
    
    func completeWithError() {
        router.invokeOnError()
    }
    
    // MARK: - Private

    private func startObserving() {
        model.status
            .subscribe(onNext: { [weak self] status in self?.handle(transactionStatus: status) })
            .add(to: disposer)
        
        model.startObserving()
    }
    
    private func handle(transactionStatus: Domain.OngoingTransaction.Status) {
        switch transactionStatus {
        case .correct:
            router.invokeOnSuccess()
        case .error:
            router.invokeOnError()
        default:
            break
        }
    }
}
