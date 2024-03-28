//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

extension ChannelDTO {
    
    struct Constraint: Decodable {
        
        let field: String
        let type: String
        let value: String
    }
}
