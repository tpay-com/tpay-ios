//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithAmbiguousBlikAliasesViewModel: PayWithAmbiguousBlikAliasesViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    let isValid = Observable<Bool>()
    
    // MARK: - Properties
    
    var blikAliases: [Domain.Blik.OneClick.Alias] { model.blikAliases }
    var transaction: Domain.Transaction { model.transactionDetails }
    
    private let model: PayWithAmbiguousBlikAliasesModel
    private let router: PayWithAmbiguousBlikAliasesRouter
    
    private var selectedBlikAlias: Domain.Blik.OneClick.Alias?
    
    // MARK: - Initializers
    
    init(model: PayWithAmbiguousBlikAliasesModel, router: PayWithAmbiguousBlikAliasesRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func select(blikAlias: Domain.Blik.OneClick.Alias) {
        selectedBlikAlias = blikAlias
        isValid.on(.next(true))
    }
    
    func invokePayment() {
        guard let selectedBlikAlias = selectedBlikAlias else {
            isValid.on(.next(false))
            return
        }
        
        startProcessing()
        model.continuePayment(with: Domain.Blik.OneClick(alias: selectedBlikAlias)) { [weak self] result in
            self?.stopProcessing()
            guard let self = self else { return }
            switch result {
            case .success(let ongoingTransaction):
                self.router.invokeOnTransactionCreated(with: ongoingTransaction)
            case .failure(let error):
                self.router.invokeOnError(with: error)
            }
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
}
