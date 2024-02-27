//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct NewTransactionDTO: Encodable {
    
    // MARK: - Properties
    
    let amount: Decimal
    
    let description: String?
    let hiddenDescription: String?
    let language: Language?
    
    let pay: PayWithInstantRedirectionDTO
    let payer: PayerDTO
    
    let callbacks: Callbacks
}

extension NewTransactionDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case amount
        
        case description
        case hiddenDescription
        case language = "lang"
        
        case pay
        case payer
        
        case callbacks
    }
}
