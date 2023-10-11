//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardViewModel {
    
    // MARK: - Events
    
    var cardNumberState: Observable<InputContentState> { get }
    var cardExpiryDateState: Observable<InputContentState> { get }
    var cardSecurityCodeState: Observable<InputContentState> { get }
    var cardBrand: Observable<CardNumberDetectionModels.CreditCard.Brand?> { get }
    var cardData: Observable<CardNumberDetectionModels.CreditCard> { get }
    
    var isProcessing: Observable<Bool> { get }

    // MARK: - Properties
    
    var transaction: Domain.Transaction { get }
    var isNavigationToOneClickEnabled: Bool { get }
    var merchantDetails: Domain.MerchantDetails { get }
        
    var cardNumber: String { get }
    var cardExpiryDate: String { get }
    var cardSecurityCode: String { get }
    
    // MARK: - API
    
    func set(cardNumber: String)
    func set(cardExpiryDate: String)
    func set(cardSecurityCode: String)
    func set(cardData: CardNumberDetectionModels.CreditCard)
    
    func set(shouldSaveCard: Bool)
    
    func resetCardSecurityCode()

    func invokeCardScan()
    func navigateBackToOneClick()
    func invokePayment()
}
