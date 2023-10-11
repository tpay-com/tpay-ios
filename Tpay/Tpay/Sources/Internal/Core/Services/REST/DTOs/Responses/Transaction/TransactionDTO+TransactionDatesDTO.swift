//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionDTO {
    
    struct TransactionDatesDTO: Decodable {
        
        // MARK: - Properties
        
        let creation: String
        let realization: String?
    }
}
