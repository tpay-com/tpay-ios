//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

protocol TransactionValidator: AnyObject {
    
    // MARK: - API
    
    func validate(transaction: Domain.OngoingTransaction) throws
}
