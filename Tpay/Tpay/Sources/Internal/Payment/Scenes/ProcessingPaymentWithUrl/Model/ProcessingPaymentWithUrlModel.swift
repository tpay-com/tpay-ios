//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingPaymentWithUrlModel: AnyObject {
    
    // MARK: - Events
    
    var status: Observable<Domain.OngoingTransaction.Status> { get }
    
    // MARK: - Properties
    
    var continueUrl: URL { get }
    
    var successUrl: URL { get }
    var errorUrl: URL { get }
    
    // MARK: - API
    
    func startObserving()
    func stopObserving()
}
