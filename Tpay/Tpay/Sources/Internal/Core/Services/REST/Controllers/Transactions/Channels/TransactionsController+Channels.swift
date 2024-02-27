//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct Channels: NetworkRequest {
        
        typealias ResponseType = Response
        
        // MARK: - Properties
        
        let resource = NetworkResource(url: URL(staticString: "/transactions/channels"), method: .get, contentType: .none, authorization: .bearer)
    }
}
