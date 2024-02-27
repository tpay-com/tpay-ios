//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

protocol PayWithRatyPekaoViewModel {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    var isValid: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var paymentVariants: [Domain.PaymentMethod.InstallmentPayment] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func select(paymentVariant: Domain.PaymentMethod.InstallmentPayment)
    
    func invokePayment()
}
