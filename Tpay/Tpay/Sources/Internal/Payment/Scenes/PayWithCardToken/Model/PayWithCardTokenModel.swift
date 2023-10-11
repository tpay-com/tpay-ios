//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithCardTokenModel: AnyObject {
    
    // MARK: - Properties
    
    var cardTokens: [Domain.CardToken] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func invokePayment(with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler)
}
