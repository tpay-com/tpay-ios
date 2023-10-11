//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithAmbiguousBlikAliasesModel: AnyObject {
    
    // MARK: - Properties
    
    var blikAliases: [Domain.Blik.OneClick.Alias] { get }
    var transaction: Domain.OngoingTransaction { get }
    var transactionDetails: Domain.Transaction { get }
    
    // MARK: - API
    
    func continuePayment(with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler)
}
