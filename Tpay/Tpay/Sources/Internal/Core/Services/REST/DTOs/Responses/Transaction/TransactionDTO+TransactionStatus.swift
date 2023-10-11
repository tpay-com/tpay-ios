//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionDTO {
    
    enum TransactionStatus: String, Decodable {
        
        // MARK: - Cases
        
        case pending
        case paid
        case correct
        case refund
        case error
    }
}
