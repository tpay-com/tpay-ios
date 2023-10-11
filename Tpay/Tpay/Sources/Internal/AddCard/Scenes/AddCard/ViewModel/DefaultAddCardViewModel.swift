//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultAddCardViewModel: AddCardViewModel {
    
    // MARK: - Events
    
    private(set) lazy var payerNameState: Observable<InputContentState> = _payerNameState.asObservable()
    private(set) lazy var payerEmailState: Observable<InputContentState> = _payerEmailState.asObservable()
    private(set) lazy var cardNumberState: Observable<InputContentState> = _cardNumberState.asObservable()
    private(set) lazy var cardExpiryDateState: Observable<InputContentState> = _cardExpiryDateState.asObservable()
    private(set) lazy var cardSecurityCodeState: Observable<InputContentState> = _cardSecurityCodeState.asObservable()
    
    let cardBrand = Observable<CardNumberDetectionModels.CreditCard.Brand?>()
    let cardData = Observable<CardNumberDetectionModels.CreditCard>()
    let isProcessing = Observable<Bool>()
    
    // MARK: - Properties
    
    var initialPayerName: String?
    var initialPayerEmail: String?
    
    let merchantDetails: Domain.MerchantDetails
    
    var payerName: String { _payerName.input }
    var payerEmail: String { _payerEmail.input }
    var cardNumber: String { _cardNumber.input }
    var cardExpiryDate: String { _cardExpiryDate.input }
    var cardSecurityCode: String { _cardSecurityCode.input }
    
    private let model: AddCardModel
    private let router: AddCardRouter
    
    private let _payerNameState = Variable<InputContentState>(.notDetermined)
    private let _payerEmailState = Variable<InputContentState>(.notDetermined)
    private let _cardNumberState = Variable<InputContentState>(.notDetermined)
    private let _cardExpiryDateState = Variable<InputContentState>(.notDetermined)
    private let _cardSecurityCodeState = Variable<InputContentState>(.notDetermined)
    
    private let _payerEmail = EmailValidation()
    private let _payerName = NameValidation()
    private let _cardNumber = CardNumberValidation()
    private let _cardExpiryDate = CardExpiryDateValidation()
    private let _cardSecurityCode = CardSecurityCodeValidation()
    
    // MARK: - Initializers
    
    init(model: AddCardModel, router: AddCardRouter) {
        self.model = model
        self.router = router
        
        initialPayerName = model.payer?.name
        initialPayerEmail = model.payer?.email
        merchantDetails = model.merchantDetails
        
        set(payerName: initialPayerName ?? .empty)
        set(payerEmail: initialPayerEmail ?? .empty)
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
    
    func set(cardNumber: String) {
        _cardNumber.validate(cardNumber.removeWhitespacesAndNewlines().removeDashes())
        _cardNumberState.value = .init(_cardNumber.result)
        cardBrand.on(.next(_cardNumber.brand))
    }
    
    func set(cardExpiryDate: String) {
        _cardExpiryDate.validate(cardExpiryDate)
        _cardExpiryDateState.value = .init(_cardExpiryDate.result)
    }
    
    func set(cardSecurityCode: String) {
        _cardSecurityCode.validate(cardSecurityCode)
        _cardSecurityCodeState.value = .init(_cardSecurityCode.result)
    }
    
    func set(cardData: CardNumberDetectionModels.CreditCard) {
        self.cardData.on(.next(cardData))
        set(cardNumber: cardData.number)
        if let expiryDate = cardData.expiryDate {
            set(cardExpiryDate: expiryDate)
        }
    }
    
    func resetCardSecurityCode() {
        set(cardSecurityCode: .empty)
    }
    
    func invokeCardScan() {
        router.invokeOnCardScan()
    }
    
    func saveCard() {
        validate()
        guard _payerName.isValid, _payerEmail.isValid, _cardNumber.isValid, _cardExpiryDate.isValid, _cardSecurityCode.isValid else { return }
        
        guard let expiryDate = try? makeExpiryDate(), !expiryDate.checkIsBackDate() else {
            _cardExpiryDateState.value = .init(.invalidCardExpiryDate)
            return
        }
        
        do {
            let card = try makeCard()
            tokenize(card)
        } catch {
            Logger.info(error.localizedDescription)
        }
    }
    
    func close() {
        router.close()
    }
    
    // MARK: - Private
    
    private func validate() {
        _payerName.forceValidation()
        _payerEmail.forceValidation()
        _cardNumber.forceValidation()
        _cardExpiryDate.forceValidation()
        _cardSecurityCode.forceValidation()
        
        _payerNameState.value = .init(_payerName.result)
        _payerEmailState.value = .init(_payerEmail.result)
        _cardNumberState.value = .init(_cardNumber.result)
        _cardExpiryDateState.value = .init(_cardExpiryDate.result)
        _cardSecurityCodeState.value = .init(_cardSecurityCode.result)
    }
    
    private func makeCard() throws -> Domain.Card {
        Domain.Card(number: cardNumber,
                    expiryDate: try makeExpiryDate(),
                    securityCode: cardSecurityCode,
                    shouldTokenize: true)
    }
    
    private func makeExpiryDate() throws -> Domain.Card.ExpiryDate {
        guard let expiryDate = Domain.Card.ExpiryDate.make(from: cardExpiryDate) else {
            throw AddCardError.invalidExpiryDate
        }
        return expiryDate
    }
    
    private func makePayer() -> Domain.Payer {
        Domain.Payer(name: payerName, email: payerEmail, phone: nil, address: nil)
    }
    
    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func tokenize(_ card: Domain.Card) {
        startProcessing()
        model.tokenize(card, payer: makePayer()) { [weak self] result in
            self?.stopProcessing()
            guard let self = self else { return }
            switch result {
            case .success(let transaction):
                self.router.invokeOnSuccess(transaction)
            case .failure(let error):
                self.router.invokeOnError(with: error)
            }
        }
    }
}
