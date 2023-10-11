//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayByLinkViewModel: AnyObject {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    var isValid: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var banks: [Domain.PaymentMethod.Bank] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func select(bank: Domain.PaymentMethod.Bank)
    
    func invokePayment()
}
