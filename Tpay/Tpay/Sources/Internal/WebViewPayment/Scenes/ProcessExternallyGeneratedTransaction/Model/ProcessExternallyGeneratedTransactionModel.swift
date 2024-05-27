//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol ProcessExternallyGeneratedTransactionModel: AnyObject {
    
    // MARK: - API
    
    var transaction: ExternallyGeneratedTransaction { get }
}
