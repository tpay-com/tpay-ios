//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPayWithCardViewModel: PayWithCardViewModel {
    
    // MARK: - Events
    
    private(set) lazy var cardNumberState: Observable<InputContentState> = _cardNumberState.asObservable()
    private(set) lazy var cardExpiryDateState: Observable<InputContentState> = _cardExpiryDateState.asObservable()
    private(set) lazy var cardSecurityCodeState: Observable<InputContentState> = _cardSecurityCodeState.asObservable()
    
    let cardBrand = Observable<CardNumberDetectionModels.CreditCard.Brand?>()
    let cardData = Observable<CardNumberDetectionModels.CreditCard>()
    let isProcessing = Observable<Bool>()
    
    // MARK: - Properties
    
    let transaction: Domain.Transaction
    let isNavigationToOneClickEnabled: Bool
    let merchantDetails: Domain.MerchantDetails
    
    var cardNumber: String { _cardNumber.input }
    var cardExpiryDate: String { _cardExpiryDate.input }
    var cardSecurityCode: String { _cardSecurityCode.input }
    
    private let model: PayWithCardModel
    private let router: PayWithCardRouter
    
    private let _cardNumberState = Variable<InputContentState>(.notDetermined)
    private let _cardExpiryDateState = Variable<InputContentState>(.notDetermined)
    private let _cardSecurityCodeState = Variable<InputContentState>(.notDetermined)
    
    private let _cardNumber = CardNumberValidation()
    private let _cardExpiryDate = CardExpiryDateValidation()
    private let _cardSecurityCode = CardSecurityCodeValidation()
    
    private var shouldSaveCard = false
    
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, model: PayWithCardModel, router: PayWithCardRouter, isNavigationToOneClickEnabled: Bool = false) {
        self.transaction = transaction
        self.model = model
        self.router = router
        self.isNavigationToOneClickEnabled = isNavigationToOneClickEnabled
        merchantDetails = model.merchantDetails
    }
    
    // MARK: - API
    
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
    
    func set(shouldSaveCard: Bool) {
        self.shouldSaveCard = shouldSaveCard
    }
    
    func resetCardSecurityCode() {
        set(cardSecurityCode: .empty)
    }
    
    func invokeCardScan() {
        router.invokeOnCardScan()
    }
    
    func navigateBackToOneClick() {
        router.invokeOnNavigateToOneClick()
    }
    
    func invokePayment() {
        validate()
        guard _cardNumber.isValid, _cardExpiryDate.isValid, _cardSecurityCode.isValid else {
            return
        }
        guard let expiryDate = try? makeExpiryDate(), !expiryDate.checkIsBackDate() else {
            _cardExpiryDateState.value = .init(.invalidCardExpiryDate)
            return
        }
        
        do {
            let card = try makeCard()
            payment(with: card)
        } catch {
            Logger.info(error.localizedDescription)
        }
    }
    
    // MARK: - Private
    
    private func validate() {
        _cardNumber.forceValidation()
        _cardExpiryDate.forceValidation()
        _cardSecurityCode.forceValidation()
        
        _cardNumberState.value = .init(_cardNumber.result)
        _cardExpiryDateState.value = .init(_cardExpiryDate.result)
        _cardSecurityCodeState.value = .init(_cardSecurityCode.result)
    }
    
    private func makeCard() throws -> Domain.Card {
        Domain.Card(number: cardNumber,
                    expiryDate: try makeExpiryDate(),
                    securityCode: cardSecurityCode,
                    shouldTokenize: shouldSaveCard)
    }
    
    private func makeExpiryDate() throws -> Domain.Card.ExpiryDate {
        guard let expiryDate = Domain.Card.ExpiryDate.make(from: cardExpiryDate) else {
            throw PayWithCardError.invalidExpiryDate
        }
        return expiryDate
    }
    
    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
    
    private func payment(with card: Domain.Card) {
        startProcessing()
        model.invokePayment(for: transaction, with: card) { [weak self] result in
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
}
