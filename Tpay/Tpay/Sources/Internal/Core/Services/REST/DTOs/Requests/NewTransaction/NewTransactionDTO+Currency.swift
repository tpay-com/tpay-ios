//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension NewTransactionDTO {
    
    enum Currency: String, Encodable {
        
        // MARK: - Cases
        
        case pln = "PLN"
        case gpb = "GPB"
        case usd = "USD"
        case eur = "EUR"
        case czk = "CZK"
        case nok = "NOK"
        case dkk = "DKK"
        case sek = "SEK"
        case chf = "CHF"
    }
}
