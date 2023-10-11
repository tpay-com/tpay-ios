//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Synchronizes all the data that is required to conduct a payment process
protocol SynchronizationService: AnyObject {
    
    // MARK: - Events
    
    var synchronizationStatus: Variable<Domain.SynchronizationStatus> { get }
    
    // MARK: - API
    
    func fetchPaymentData(then: @escaping Completion)
    func prefetchRemoteResources(then: @escaping Completion)
}
