//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class ApplePaySessionDTO: ResponseDTO {
    
    // MARK: - Properties
    
    let session: String
    
    // MARK: - Initializers
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        session = try container.decode(String.self, forKey: .session)
        
        try super.init(from: decoder)
    }
}

extension ApplePaySessionDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case session
    }
}
