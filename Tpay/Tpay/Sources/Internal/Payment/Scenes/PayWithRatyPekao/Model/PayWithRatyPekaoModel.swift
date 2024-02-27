//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol PayWithRatyPekaoModel: AnyObject {
    
    var installmentPayments: [Domain.PaymentMethod.InstallmentPayment] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func invokePayment(with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler)
}
