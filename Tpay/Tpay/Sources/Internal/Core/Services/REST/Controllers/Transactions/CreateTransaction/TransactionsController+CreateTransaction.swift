//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct CreateTransaction: Encodable {
                
        // MARK: - Properties
     
        let dto: NewTransactionDTO
        
        // MARK: - Initializers
        
        init(dto: NewTransactionDTO) {
            self.dto = dto
        }
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            try dto.encode(to: encoder)
        }
    }
}

extension TransactionsController.CreateTransaction: NetworkRequest {
    
    typealias ResponseType = TransactionDTO
    
    // MARK: - Properties
    
    var resource: NetworkResource {
        NetworkResource(url: URL(staticString: "/transactions"), method: .post, contentType: .json, authorization: .bearer)
    }
}
