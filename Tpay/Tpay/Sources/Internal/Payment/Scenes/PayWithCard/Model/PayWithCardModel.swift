//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardModel: AnyObject {
    
    // MARK: - Properties
    
    var merchantDetails: Domain.MerchantDetails { get }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with card: Domain.Card, then: @escaping OngoingTransactionResultHandler)
}
