//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionDTO.Payments {
    
    struct TransactionDataError: Decodable {
        
        // MARK: - Properties
        
        let errorCode: String?
        let errorMessage: String?
        let devMessage: String?
    }
}
