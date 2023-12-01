//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension TransactionDTO.Payments.Attempt {
    
    enum AttemptError: String, Decodable {
        
        // MARK: - Cases
        
        case blikUnknownError = "100"
        case blikPaymentDeclined = "101"
        case blikGeneralError = "102"
        case blikInsufficentFunds = "103"
        case blikTimeout = "104"
    }
}
