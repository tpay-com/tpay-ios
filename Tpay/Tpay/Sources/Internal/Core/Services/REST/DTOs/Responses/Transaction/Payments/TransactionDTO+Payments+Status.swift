//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension TransactionDTO.Payments {
    
    enum Status: String, Decodable {
        
        // MARK: - Cases
        
        case correct
        case declined
        case pending
    }
}
