//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol AddCardModel: AnyObject {
    
    // MARK: - Properties
    
    var payer: Payer? { get }
    var merchantDetails: Domain.MerchantDetails { get }
    
    // MARK: - API
    
    func tokenize(_ card: Domain.Card, payer: Domain.Payer, then: @escaping (Result<Domain.OngoingTokenization, Error>) -> Void)
}
