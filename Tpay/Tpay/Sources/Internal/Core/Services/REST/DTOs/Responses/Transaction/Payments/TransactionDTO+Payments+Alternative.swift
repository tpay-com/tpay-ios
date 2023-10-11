//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension TransactionDTO.Payments {
    
    struct Alternative: Decodable {
        
        let applicationName: String
        let applicationCode: String
    }
}
