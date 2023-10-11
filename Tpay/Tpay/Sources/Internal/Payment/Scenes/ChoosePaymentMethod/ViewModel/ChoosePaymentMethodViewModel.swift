//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ChoosePaymentMethodViewModel: AnyObject {
    
    // MARK: - Properties
    
    var paymentMethods: Observable<[Domain.PaymentMethod]> { get }
    var initialPaymentMethod: Domain.PaymentMethod { get }
    
    // MARK: - Methods
    
    func choose(method: Domain.PaymentMethod)
    func getPaymentMethods() -> [Domain.PaymentMethod]
}
