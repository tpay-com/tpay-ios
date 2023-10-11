//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol CardTokenPaymentViewModel: AnyObject {
    
    // MARK: - Properties
    
    var title: String { get }
    var message: String { get }
    
    // MARK: - API
    
    func invokePayment()
}
