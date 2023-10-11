//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PaymentDataStore: AnyObject {
    
    // MARK: - Properties

    var paymentMethods: [Domain.PaymentMethod] { get }
    
    // MARK: - API

    func set(paymentMethods: [Domain.PaymentMethod])
}
