//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithBlikCodeViewModel: PayWithBlikCodeViewModel {
    
    // MARK: - Events
    
    private(set) lazy var blikCodeState: Observable<InputContentState> = _blikCodeState.asObservable()
    
    let isProcessing = Observable<Bool>()
    
    // MARK: - Properties
    
    let transaction: Domain.Transaction
    let isNavigationToOneClickEnabled: Bool
    let shouldAllowAliasRegistration: Bool
        
    private let model: PayWithBlikCodeModel
    private let router: PayWithBlikCodeRouter
    
    private let _blikCodeState = Variable<InputContentState>(.notDetermined)
    private let _blikCode = BlikCodeValidation()
    
    private var shouldRegisterAlias = false
    private var aliasLabel: String?
    
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, model: PayWithBlikCodeModel, router: PayWithBlikCodeRouter, isNavigationToOneClickEnabled: Bool) {
        self.transaction = transaction
        self.model = model
        self.router = router
        self.isNavigationToOneClickEnabled = isNavigationToOneClickEnabled
        self.shouldAllowAliasRegistration = model.aliasToBeRegistered != nil
    }
    
    // MARK: - API
    
    func set(blikCode: String) {
        _blikCode.validate(blikCode)
        _blikCodeState.value = .init(_blikCode.result)
    }
    
    func set(shouldRegisterAlias: Bool) {
        self.shouldRegisterAlias = shouldRegisterAlias
    }
    
    func set(aliasLabel: String?) {
        self.aliasLabel = aliasLabel
    }
    
    func navigateBackToOneClick() {
        router.invokeOnNavigateToOneClick()
    }
    
    func invokePayment() {
        validate()
        guard _blikCode.isValid else { return }
        
        startProcessing()
        model.invokePayment(for: transaction, with: makeBlik()) { [weak self] result in
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
    
    // MARK: - Private
    
    private func validate() {
        _blikCode.forceValidation()
        _blikCodeState.value = .init(_blikCode.result)
    }
    
    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func makeBlik() -> Domain.Blik.Regular {
        Domain.Blik.Regular(token: _blikCode.input, alias: resolveBlikAlias())
    }
    
    private func resolveBlikAlias() -> Domain.Blik.Regular.Alias? {
        guard shouldRegisterAlias, var alias = model.aliasToBeRegistered else {
            return nil
        }
        guard let label = aliasLabel else {
            return alias
        }
        return alias.labeled(with: label)
    }
}
