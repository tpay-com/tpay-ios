//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayByLinkModel: AnyObject {
 
    var banks: [Domain.PaymentMethod.Bank] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func invokePayment(with bank: Domain.PaymentMethod.Bank, then: @escaping OngoingTransactionResultHandler)
}
