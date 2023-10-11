//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct PayForSpecifiedTransaction: NetworkRequest {
        
        typealias ResponseType = TransactionDTO
                
        // MARK: - Properties
     
        let dto: PayDTO
        let resource: NetworkResource
        
        // MARK: - Initializers
        
        init(transactionId: String, dto: PayDTO) {
            self.dto = dto
            resource = NetworkResource(url: URL(safeString: "/transactions/" + transactionId + "/pay"),
                                       method: .post,
                                       contentType: .json,
                                       authorization: .bearer)
        }
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            try dto.encode(to: encoder)
        }
    }
}
