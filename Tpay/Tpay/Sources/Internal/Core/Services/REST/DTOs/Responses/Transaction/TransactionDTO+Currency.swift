//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionDTO {
    
    enum Currency: String, Decodable {
        
        // MARK: - Cases
        
        case PLN
        case GPB
        case USD
        case EUR
        case CZK
        case NOK
        case DKK
        case SEK
        case CHF
    }
}
