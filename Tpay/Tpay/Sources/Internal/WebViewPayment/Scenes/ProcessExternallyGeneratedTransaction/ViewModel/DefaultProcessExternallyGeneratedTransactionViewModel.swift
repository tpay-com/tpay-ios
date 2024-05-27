//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultProcessExternallyGeneratedTransactionViewModel: ProcessExternallyGeneratedTransactionViewModel {
    
    // MARK: - Events

    // MARK: - Properties
    
    var transactionPaymentUrl: URL { model.transaction.transactionPaymentUrl }
    var successUrl: URL { model.transaction.onSuccessRedirectUrl }
    var errorUrl: URL { model.transaction.onErrorRedirectUrl }

    private let model: ProcessExternallyGeneratedTransactionModel
    private let router: ProcessExternallyGeneratedTransactionRouter
    
    // MARK: - Initializers

    init(model: ProcessExternallyGeneratedTransactionModel, router: ProcessExternallyGeneratedTransactionRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func completeWithSuccess() {
        router.invokeOnSuccess()
    }
    
    func completeWithError() {
        router.invokeOnError()
    }
}
