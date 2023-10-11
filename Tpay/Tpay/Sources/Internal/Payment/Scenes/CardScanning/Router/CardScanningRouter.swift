//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CardScanningRouter: AnyObject {
    
    // MARK: - Events
    
    var closeAction: Observable<Void> { get }
    var completeAction: Observable<CardNumberDetectionModels.CreditCard> { get }
    
    // MARK: - API
    
    func close()
    func complete(with cardData: CardNumberDetectionModels.CreditCard)
}
