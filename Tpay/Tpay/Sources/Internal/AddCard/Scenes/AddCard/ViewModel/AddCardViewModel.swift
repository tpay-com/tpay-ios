//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol AddCardViewModel: AnyObject {
    
    // MARK: - Events
    
    var payerNameState: Observable<InputContentState> { get }
    var payerEmailState: Observable<InputContentState> { get }
    var cardNumberState: Observable<InputContentState> { get }
    var cardExpiryDateState: Observable<InputContentState> { get }
    var cardSecurityCodeState: Observable<InputContentState> { get }
    var cardBrand: Observable<CardNumberDetectionModels.CreditCard.Brand?> { get }
    var cardData: Observable<CardNumberDetectionModels.CreditCard> { get }
    
    var isProcessing: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var initialPayerName: String? { get }
    var initialPayerEmail: String? { get }
    
    var merchantDetails: Domain.MerchantDetails { get }
    
    var payerName: String { get }
    var payerEmail: String { get }
    var cardNumber: String { get }
    var cardExpiryDate: String { get }
    var cardSecurityCode: String { get }
    
    // MARK: - API
    
    func set(payerName: String)
    func set(payerEmail: String)
    func set(cardNumber: String)
    func set(cardExpiryDate: String)
    func set(cardSecurityCode: String)
    func set(cardData: CardNumberDetectionModels.CreditCard)
    
    func resetCardSecurityCode()
    
    func invokeCardScan()
    func saveCard()
    func close()
}
