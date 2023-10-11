//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct SpecifiedTransaction: NetworkRequest {
        
        typealias ResponseType = TransactionDTO
        
        // MARK: - Properties
                
        let resource: NetworkResource
        
        // MARK: - Initializers
        
        init(with transactionId: String) {
            resource = NetworkResource(url: URL(safeString: "/transactions/" + transactionId), method: .get, contentType: .none, authorization: .bearer)
        }
    }
}
