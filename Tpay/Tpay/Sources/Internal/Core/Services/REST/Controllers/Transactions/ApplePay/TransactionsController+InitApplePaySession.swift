//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionsController {
    
    struct InitApplePaySession: Encodable {
        
        // MARK: - Properties
        
        let dto: NewApplePaySessionDTO
        
        // MARK: - Initializers
        
        init(dto: NewApplePaySessionDTO) {
            self.dto = dto
        }
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            try dto.encode(to: encoder)
        }
    }
}

extension TransactionsController.InitApplePaySession: NetworkRequest {
    
    typealias ResponseType = ApplePaySessionDTO
    
    // MARK: - Properties
    
    var resource: NetworkResource {
        NetworkResource(url: URL(staticString: "/wallet/applepay/init"), method: .post, contentType: .json, authorization: .bearer)
    }
}
