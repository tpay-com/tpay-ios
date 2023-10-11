//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithBlikAliasViewModel: AnyObject {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func navigateToBlikCode()
    func invokePayment()
}
