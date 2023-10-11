//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingPaymentModel: AnyObject {
    
    // MARK: - Properties
    
    var status: Observable<Domain.OngoingTransaction.Status> { get }
    
    // MARK: - API
    
    func startObserving()
    func stopObserving()
}
