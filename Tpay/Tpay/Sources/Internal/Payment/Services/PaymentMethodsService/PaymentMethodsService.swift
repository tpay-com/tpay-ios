//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PaymentMethodsService: AnyObject {
    
    // MARK: - Properties
    
    var paymentMethods: [Domain.PaymentMethod] { get }
    var paymentChannels: [Domain.PaymentChannel] { get }
    
    // MARK: - API
    
    func store(availablePaymentMethods: [Domain.PaymentMethod], completion: @escaping Completion)
    func store(paymentChannels: [Domain.PaymentChannel], completion: @escaping Completion)
}
