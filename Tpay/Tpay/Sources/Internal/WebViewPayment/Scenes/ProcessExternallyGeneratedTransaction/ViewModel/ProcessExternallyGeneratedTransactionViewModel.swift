//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol ProcessExternallyGeneratedTransactionViewModel {
    
    // MARK: - Properties
    
    var transactionPaymentUrl: URL { get }
    var successUrl: URL { get }
    var errorUrl: URL { get }
    
    // MARK: - API

    func completeWithSuccess()
    func completeWithError()
}
