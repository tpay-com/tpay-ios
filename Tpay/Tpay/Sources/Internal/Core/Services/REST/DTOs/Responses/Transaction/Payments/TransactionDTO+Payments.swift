//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionDTO {
    
    struct Payments: Decodable {
        
        // MARK: - Properties
        
        let attempts: [Attempt]?
        let alternatives: [Alternative]?
        let errors: [TransactionDataError]?
        
        // MARK: - Initializers
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            attempts = try container.decodeIfPresent([Attempt].self, forKey: .attempts)
            alternatives = try container.decodeIfPresent([Alternative].self, forKey: .alternatives)
            errors = try container.decodeIfPresent([TransactionDataError].self, forKey: .errors)
        }
    }
}

extension TransactionDTO.Payments {
    
    private enum CodingKeys: CodingKey {
        
        // MARK: - Cases
        
        case alternatives
        case attempts
        case errors
    }
}
