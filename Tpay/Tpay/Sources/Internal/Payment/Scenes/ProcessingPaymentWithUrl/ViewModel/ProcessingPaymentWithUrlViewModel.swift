//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingPaymentWithUrlViewModel {
    
    // MARK: - Properties
    
    var continueUrl: URL { get }
    var successUrl: URL { get }
    var errorUrl: URL { get }
    
    // MARK: - API

    func completeWithSuccess()
    func completeWithError()
}
