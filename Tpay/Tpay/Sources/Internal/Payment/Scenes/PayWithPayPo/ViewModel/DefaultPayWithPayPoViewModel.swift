//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultPayWithPayPoViewModel: PayWithPayPoViewModel {
    
    // MARK: - Events
    
    private(set) lazy var payerNameState: Observable<InputContentState> = _payerNameState.asObservable()
    private(set) lazy var payerEmailState: Observable<InputContentState> = _payerEmailState.asObservable()
    private(set) lazy var payerStreetAdressState: Observable<InputContentState> = _payerStreetAdressState.asObservable()
    private(set) lazy var payerPostalCodeAdressState: Observable<InputContentState> = _payerPostalCodeAdressState.asObservable()
    private(set) lazy var payerCityAdressState: Observable<InputContentState> = _payerCityAdressState.asObservable()
    
    let isProcessing = Observable<Bool>()

    // MARK: - Properties
    
    var transaction: Domain.Transaction { model.transaction }
    var merchantDetails: Domain.MerchantDetails { model.merchantDetails }
    
    var payerName: String { _payerName.input }
    var payerEmail: String { _payerEmail.input }
    var payerStreetAdress: String { _payerStreetAdress.input }
    var payerPostalCodeAdress: String { _payerPostalCodeAdress.input }
    var payerCityAdress: String { _payerCityAdress.input }
    
    private let model: PayWithPayPoModel
    private let router: PayWithPayPoRouter
    
    private let _payerNameState = Variable<InputContentState>(.notDetermined)
    private let _payerEmailState = Variable<InputContentState>(.notDetermined)
    private let _payerStreetAdressState = Variable<InputContentState>(.notDetermined)
    private let _payerPostalCodeAdressState = Variable<InputContentState>(.notDetermined)
    private let _payerCityAdressState = Variable<InputContentState>(.notDetermined)
    
    private let _payerName = NameValidation()
    private let _payerEmail = EmailValidation()
    private let _payerStreetAdress = StreetAddressValidation()
    private let _payerPostalCodeAdress = PostalCodeValidation()
    private let _payerCityAdress = CityAddressValidation()
    
    // MARK: - Initializers

    init(model: PayWithPayPoModel, router: PayWithPayPoRouter) {
        self.model = model
        self.router = router
        
        set(payerName: transaction.payer.name)
        set(payerEmail: transaction.payer.email)
        set(payerStreetAdress: transaction.payer.address?.address ?? .empty)
        set(payerPostalCodeAdress: transaction.payer.address?.postalCode ?? .empty)
        set(payerCityAdress: transaction.payer.address?.city ?? .empty)
    }
    
    // MARK: - API
    
    func set(payerName: String) {
        _payerName.validate(payerName)
        _payerNameState.value = .init(_payerName.result)
    }
    
    func set(payerEmail: String) {
        _payerEmail.validate(payerEmail)
        _payerEmailState.value = .init(_payerEmail.result)
    }
    
    func set(payerStreetAdress: String) {
        _payerStreetAdress.validate(payerStreetAdress)
        _payerStreetAdressState.value = .init(_payerStreetAdress.result)
    }

    func set(payerPostalCodeAdress: String) {
        _payerPostalCodeAdress.validate(payerPostalCodeAdress)
        _payerPostalCodeAdressState.value = .init(_payerPostalCodeAdress.result)
    }
    
    func set(payerCityAdress: String) {
        _payerCityAdress.validate(payerCityAdress)
        _payerCityAdressState.value = .init(_payerCityAdress.result)
    }
    
    func invokePayment() {
        validate()
        guard _payerName.isValid,
              _payerEmail.isValid,
              _payerStreetAdress.isValid,
              _payerPostalCodeAdress.isValid,
              _payerCityAdress.isValid else {
            return
        }
        startProcessing()
        model.invokePayment(with: makePayPoPayer()) { [weak self] result in
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
    
    private func validate() {
        _payerName.forceValidation()
        _payerEmail.forceValidation()
        _payerStreetAdress.forceValidation()
        _payerPostalCodeAdress.forceValidation()
        _payerCityAdress.forceValidation()
        
        _payerNameState.value = .init(_payerName.result)
        _payerEmailState.value = .init(_payerEmail.result)
        _payerStreetAdressState.value = .init(_payerStreetAdress.result)
        _payerPostalCodeAdressState.value = .init(_payerPostalCodeAdress.result)
        _payerCityAdressState.value = .init(_payerCityAdress.result)
    }
    
    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func makePayPoPayer() -> Domain.Payer {
        Domain.Payer(name: payerName,
                     email: payerEmail,
                     phone: nil,
                     address: .init(address: payerStreetAdress,
                                    city: payerCityAdress,
                                    country: "PL",
                                    postalCode: payerPostalCodeAdress))
    }
}
