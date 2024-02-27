//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol PaymentDataStore: AnyObject {
    
    // MARK: - Properties

    var paymentMethods: [Domain.PaymentMethod] { get }
    var paymentChannels: [Domain.PaymentChannel] { get }
    
    // MARK: - API

    func set(paymentMethods: [Domain.PaymentMethod])
    func set(paymentChannels: [Domain.PaymentChannel])
}
