//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ChoosePaymentMethodModel: AnyObject {
    
    // MARK: - Events
    
    var paymentMethods: Observable<[Domain.PaymentMethod]> { get }
        
    // MARK: - Methods
    
    func getPaymentMethods() -> [Domain.PaymentMethod]
}
