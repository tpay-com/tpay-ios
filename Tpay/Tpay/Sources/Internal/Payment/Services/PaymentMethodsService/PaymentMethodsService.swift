//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PaymentMethodsService: AnyObject {
    
    // MARK: - Properties
    
    var paymentMethods: [Domain.PaymentMethod] { get }
    
    // MARK: - API
    
    func store(availablePaymentMethods: [Domain.PaymentMethod], completion: @escaping Completion)
}
