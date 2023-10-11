//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayDTO {
    
    struct Recursive: Encodable {
        
        // MARK: - Properties
        
        let period: Period
        let quantity: Int
        let type: TransactionType = .blikModelA
        let expiryDate: Date
    }
}

extension PayDTO.Recursive {
    
    enum Period: Int, Encodable {
        
        // MARK: - Cases
        
        case day = 1
        case week
        case month
        case quarter
        case year
    }
}

extension PayDTO.Recursive {
    
    enum TransactionType: Int, Encodable {
        
        // MARK: - Cases
        
        case blikModelA = 1
    }
}
