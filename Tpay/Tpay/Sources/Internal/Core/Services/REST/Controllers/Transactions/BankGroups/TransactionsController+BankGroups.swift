//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct BankGroups: NetworkRequest {
        
        typealias ResponseType = Response
        
        // MARK: - Properties
        
        let resource = NetworkResource(url: URL(staticString: "/transactions/bank-groups"), method: .get, contentType: .none, authorization: .bearer, queryParameters: Query(onlyOnline: true))
    }
}
