//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol TokenizationService: AnyObject {
    
    // MARK: - API
    
    func tokenize(_ card: Domain.Card, payer: Domain.Payer, then: @escaping (Result<Domain.OngoingTokenization, Error>) -> Void)
}
