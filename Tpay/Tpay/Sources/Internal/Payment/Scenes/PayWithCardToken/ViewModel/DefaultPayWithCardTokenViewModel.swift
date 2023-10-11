//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardTokenViewModel: PayWithCardTokenViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    
    // MARK: - Properties
    
    var cardTokens: [Domain.CardToken] { model.cardTokens }
    var transaction: Domain.Transaction { model.transaction }
    
    let initiallySelectedCardToken: Domain.CardToken?

    private let model: PayWithCardTokenModel
    private let router: PayWithCardTokenRouter
    
    private var selectedCardToken: Domain.CardToken?
    
    // MARK: - Initializers

    init(model: PayWithCardTokenModel, router: PayWithCardTokenRouter) {
        self.model = model
        self.router = router
        
        initiallySelectedCardToken = model.cardTokens.first
        selectedCardToken = initiallySelectedCardToken
    }
    
    // MARK: - API
    
    func select(cardToken: Domain.CardToken) {
        selectedCardToken = cardToken
    }
    
    func invokePayment() {
        guard let selectedCardToken = selectedCardToken else { return }
        
        startProcessing()
        model.invokePayment(with: selectedCardToken) { [weak self] result in
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
    
    func addCard() {
        router.invokeOnAddCardRequested()
    }
    
    // MARK: - Private
    
    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
}
