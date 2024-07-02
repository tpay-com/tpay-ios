//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol PayWithPayPoModel: AnyObject {
    
    var transaction: Domain.Transaction { get }
    var merchantDetails: Domain.MerchantDetails { get }
    
    // MARK: - API
    
    func invokePayment(with payPoPayer: Domain.Payer, then: @escaping OngoingTransactionResultHandler)
}
