//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct PayForSpecifiedTransaction: NetworkRequest {
        
        typealias ResponseType = TransactionDTO
                
        // MARK: - Properties
     
        let dto: PayWithInstantRedirectionDTO
        let resource: NetworkResource
        
        // MARK: - Initializers
        
        init(transactionId: String, dto: PayWithInstantRedirectionDTO) {
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
