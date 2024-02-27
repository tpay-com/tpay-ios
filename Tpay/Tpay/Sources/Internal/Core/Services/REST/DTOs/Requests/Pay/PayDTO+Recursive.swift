//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayWithInstantRedirectionDTO {
    
    struct Recursive: Encodable {
        
        // MARK: - Properties
        
        let period: Period
        let quantity: Int
        let type: TransactionType = .blikModelA
        let expiryDate: Date
    }
}

extension PayWithInstantRedirectionDTO.Recursive {
    
    enum Period: Int, Encodable {
        
        // MARK: - Cases
        
        case day = 1
        case week
        case month
        case quarter
        case year
    }
}

extension PayWithInstantRedirectionDTO.Recursive {
    
    enum TransactionType: Int, Encodable {
        
        // MARK: - Cases
        
        case blikModelA = 1
    }
}
