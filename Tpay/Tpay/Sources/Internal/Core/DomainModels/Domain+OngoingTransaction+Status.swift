//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain.OngoingTransaction {
    
    enum Status {
        
        // MARK: - Cases
        
        case pending
        case paid
        case correct
        case refund
        case error(Error)
        case unknown
    }
}
