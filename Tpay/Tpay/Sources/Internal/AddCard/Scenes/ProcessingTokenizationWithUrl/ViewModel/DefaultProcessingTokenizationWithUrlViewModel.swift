//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingTokenizationWithUrlViewModel: ProcessingTokenizationWithUrlViewModel {
    
    // MARK: - Properties
    
    var continueUrl: URL { model.continueUrl }
    var successUrl: URL { model.successUrl }
    var errorUrl: URL { model.errorUrl }
    
    private let model: ProcessingTokenizationWithUrlModel
    private let router: ProcessingTokenizationWithUrlRouter
    
    private let disposer = Disposer()
    
    // MARK: - Initializers

    init(model: ProcessingTokenizationWithUrlModel, router: ProcessingTokenizationWithUrlRouter) {
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
