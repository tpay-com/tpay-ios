//
//  Copyright © 2024 Tpay. All rights reserved.
//

final class DefaultProcessExternallyGeneratedTransactionModel: ProcessExternallyGeneratedTransactionModel {
    
    // MARK: - Properties
    
    let transaction: ExternallyGeneratedTransaction
        
    // MARK: - Initializers
    
    init(transaction: ExternallyGeneratedTransaction) {
        self.transaction = transaction
    }
}
