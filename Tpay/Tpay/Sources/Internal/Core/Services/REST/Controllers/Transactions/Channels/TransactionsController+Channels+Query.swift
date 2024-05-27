//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

extension TransactionsController.Channels {
    
    struct Query: Encodable {
        
        // MARK: - Properties
        
        let imageSize: ImageSize
    }
}

extension TransactionsController.Channels.Query {

    enum ImageSize: String, Encodable {
        
        case normal
        case medium
        case high
    }
}
