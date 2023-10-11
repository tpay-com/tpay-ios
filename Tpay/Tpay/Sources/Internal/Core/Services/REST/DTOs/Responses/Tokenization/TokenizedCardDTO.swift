//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class TokenizedCardDTO: ResponseDTO {
    
    // MARK: - Properties
    
    let id: String
    let url: String
    
    // MARK: - Initializers
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        
        try super.init(from: decoder)
    }
}

extension TokenizedCardDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case id
        case url
    }
}
