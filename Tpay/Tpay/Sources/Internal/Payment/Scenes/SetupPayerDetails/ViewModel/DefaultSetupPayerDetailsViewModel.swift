//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultSetupPayerDetailsViewModel: SetupPayerDetailsViewModel {
    
    // MARK: - Events
    
    private(set) lazy var isProcessing: Observable<Bool> = Observable()
    private(set) lazy var payerNameState: Observable<InputContentState> = _payerNameState.asObservable()
    private(set) lazy var payerEmailState: Observable<InputContentState> = _payerEmailState.asObservable()
    
    // MARK: - Properties
    
    let initialPayerName: String?
    let initialPayerEmail: String?
    
    var payerName: String { _payerName.input }
    var payerEmail: String { _payerEmail.input }
    
    private let transaction: Transaction
    
    private let model: SetupPayerDetailsModel
    private let router: SetupPayerDetailsRouter
    private let mapper: APIToDomainModelsMapper = DefaultAPIToDomainModelsMapper()
    
    private let _payerNameState = Variable<InputContentState>(.notDetermined)
    private let _payerEmailState = Variable<InputContentState>(.notDetermined)
    
    private let _payerEmail = EmailValidation()
    private let _payerName = NameValidation()
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(model: SetupPayerDetailsModel, router: SetupPayerDetailsRouter, payerOverride: Domain.Payer? = nil) {
        self.model = model
        self.router = router
        transaction = model.transaction
        
        initialPayerName = payerOverride?.name ?? transaction.payerContext?.payer?.name
        initialPayerEmail = payerOverride?.email ??  transaction.payerContext?.payer?.email
        
        set(payerName: initialPayerName ?? .empty)
        set(payerEmail: initialPayerEmail ?? .empty)
    }
    
    // MARK: - API
    
    func set(payerName: String) {
        _payerName.validate(payerName)
        _payerNameState.value = .init(_payerName.result)
        router.update(payer: makePayer())
    }
    
    func set(payerEmail: String) {
        _payerEmail.validate(payerEmail)
        _payerEmailState.value = .init(_payerEmail.result)
        router.update(payer: makePayer())
    }
    
    func choosePaymentMethod() {
        validate()
        
        guard _payerName.isValid, _payerEmail.isValid, model.synchronizationStatus.currentValue == .finished else {
            return
        }
        
        router.setup(payer: makePayer())
    }
    
    // MARK: - Private
    
    private func validate() {
        _payerName.forceValidation()
        _payerEmail.forceValidation()
        
        _payerNameState.value = .init(_payerName.result)
        _payerEmailState.value = .init(_payerEmail.result)
        
        validateSynchronization()
    }
    
    private func validateSynchronization() {
        guard model.synchronizationStatus.currentValue == .syncing else { return }
        
        model.synchronizationStatus.asObservable()
            .subscribe(onNext: { [weak self] status in
                self?.handleSynchronizationStatus(status)
            })
            .add(to: disposer)
    }
    
    private func handleSynchronizationStatus(_ status: Domain.SynchronizationStatus) {
        switch status {
        case .syncing:
            isProcessing.on(.next(true))
        case .finished:
            choosePaymentMethod()
            isProcessing.on(.next(false))
        default:
            isProcessing.on(.next(false))
        }
    }
    
    private func makePayer() -> Domain.Payer {
        Domain.Payer(name: payerName,
                     email: payerEmail,
                     phone: transaction.payerContext?.payer?.phone,
                     address: makeAddress())
    }
    
    private func makeAddress() -> Domain.Payer.Address? {
        guard let address = transaction.payerContext?.payer?.address else { return nil }
        return mapper.makeAddress(from: address)
    }
}
