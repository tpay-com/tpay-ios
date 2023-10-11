//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikAliasViewModel: PayWithBlikAliasViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    
    // MARK: - Properties
    
    var transaction: Domain.Transaction { model.transaction }
    
    private let model: PayWithBlikAliasModel
    private let router: PayWithBlikAliasRouter
    
    // MARK: - Initializers
    
    init(model: PayWithBlikAliasModel, router: PayWithBlikAliasRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func invokePayment() {
        startProcessing()
        model.invokePayment(with: Domain.Blik.OneClick(alias: model.blikAlias)) { [weak self] result in
            self?.stopProcessing()
            self?.handlePaymentResult(result)
        }
    }
    
    func navigateToBlikCode() {
        router.invokeOnNavigateToBlikCode()
    }

    // MARK: - Private

    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func handlePaymentResult(_ result: OngoingTransactionResult) {
        switch result {
        case .success(let ongoingTransaction):
            self.router.invokeOnTransactionCreated(with: ongoingTransaction)
        case .failure(let error):
            self.router.invokeOnError(with: error)
        }
    }
}
