//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol SetupPayerDetailsViewModel: AnyObject {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    var payerNameState: Observable<InputContentState> { get }
    var payerEmailState: Observable<InputContentState> { get }

    // MARK: - Properties
    
    var initialPayerName: String? { get }
    var initialPayerEmail: String? { get }
    
    var payerName: String { get }
    var payerEmail: String { get }
    
    // MARK: - API
    
    func set(payerName: String)
    func set(payerEmail: String)
        
    func choosePaymentMethod()
}
