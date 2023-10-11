//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionsController.BankGroups {

    struct Response: Decodable {
        
        let bankGroups: [BankGroupDTO]
        
        // MARK: - Initializers
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let dictionary = try container.decode([String: BankGroupDTO].self, forKey: .groups)
            
            bankGroups = Array(dictionary.values)
        }
    }
}

extension TransactionsController.BankGroups.Response {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case groups
    }
}
