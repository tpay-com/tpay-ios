//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

extension ChannelDTO {
    
    struct Constraint: Decodable {
        
        let field: Field
        let type: ConstraintType
        let value: String
    }
}

extension ChannelDTO.Constraint {
    
    enum Field: String, Decodable {
        
        case amount
        
        case applePaySession = "ApplePaySession"
    }
    
    enum ConstraintType: String, Decodable {
        
        case min
        case max
        
        case isSupported = "supported"
    }
}
