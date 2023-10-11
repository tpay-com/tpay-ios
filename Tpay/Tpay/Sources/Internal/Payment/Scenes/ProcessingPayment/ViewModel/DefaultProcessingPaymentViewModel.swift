//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingPaymentViewModel: ProcessingPaymentViewModel {
    
    // MARK: - Properties
    
    let title: String
    let message: String
    
    private let model: ProcessingPaymentModel
    private let router: ProcessingPaymentRouter
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(title: String, message: String, model: ProcessingPaymentModel, router: ProcessingPaymentRouter) {
        self.title = title
        self.message = message
        self.model = model
        self.router = router
        
        startObserving()
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
