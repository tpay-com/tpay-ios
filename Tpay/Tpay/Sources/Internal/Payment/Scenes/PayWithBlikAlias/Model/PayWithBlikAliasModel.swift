//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithBlikAliasModel: AnyObject {

    // MARK: - Properties
    
    var blikAlias: Domain.Blik.OneClick.Alias { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func invokePayment(with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler)
}
