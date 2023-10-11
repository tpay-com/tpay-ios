//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithBlikCodeModel: AnyObject {
    
    // MARK: - Properties
    
    var aliasToBeRegistered: Domain.Blik.Regular.Alias? { get }
    
    // MARK: - API
    
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler)
}
