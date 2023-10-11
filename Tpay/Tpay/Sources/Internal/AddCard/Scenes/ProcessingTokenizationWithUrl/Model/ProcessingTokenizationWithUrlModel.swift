//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingTokenizationWithUrlModel: AnyObject {
    
    // MARK: - Properties
    
    var continueUrl: URL { get }
    
    var successUrl: URL { get }
    var errorUrl: URL { get }
}
