//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayByLinkViewModel: PayByLinkViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    let isValid = Observable<Bool>()
    
    // MARK: - Properties
    
    var banks: [Domain.PaymentMethod.Bank] { model.banks }
    var transaction: Domain.Transaction { model.transaction }
    
    private let model: PayByLinkModel
    private let router: PayByLinkRouter
    
    private var selectedBank: Domain.PaymentMethod.Bank?
    
    // MARK: - Initializers
    
    init(model: PayByLinkModel, router: PayByLinkRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func select(bank: Domain.PaymentMethod.Bank) {
        selectedBank = bank
        isValid.on(.next(true))
    }
    
    func invokePayment() {
        guard let selectedBank = selectedBank else {
            isValid.on(.next(false))
            return
        }
        
        startProcessing()
        model.invokePayment(with: selectedBank) { [weak self] result in
            self?.stopProcessing()
            guard let self else { return }
            switch result {
            case .success(let ongoingTransaction):
                self.router.invokeOnTransactionCreated(with: ongoingTransaction)
            case .failure(let error):
                self.router.invokeOnError(with: error)
            }
        }
    }
    
    // MARK: - Private

    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
}
