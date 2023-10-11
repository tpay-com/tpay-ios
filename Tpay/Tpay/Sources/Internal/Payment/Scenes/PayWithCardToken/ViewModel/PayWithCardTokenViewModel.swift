//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardTokenViewModel {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var cardTokens: [Domain.CardToken] { get }
    var transaction: Domain.Transaction { get }
    
    var initiallySelectedCardToken: Domain.CardToken? { get }
    
    // MARK: - API
    
    func select(cardToken: Domain.CardToken)
    func invokePayment()
    
    func addCard()
}
