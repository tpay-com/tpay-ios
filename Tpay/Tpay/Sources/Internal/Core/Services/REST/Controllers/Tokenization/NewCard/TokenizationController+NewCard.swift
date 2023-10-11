//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TokenizationController {
    
    struct NewCard: Encodable {
                
        // MARK: - Properties
     
        let dto: NewCardDTO
        
        // MARK: - Initializers
        
        init(dto: NewCardDTO) {
            self.dto = dto
        }
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            try dto.encode(to: encoder)
        }
    }
}

extension TokenizationController.NewCard: NetworkRequest {
    
    typealias ResponseType = TokenizedCardDTO
    
    // MARK: - Properties
    
    var resource: NetworkResource {
        NetworkResource(url: URL(staticString: "/tokens"), method: .post, contentType: .json, authorization: .bearer)
    }
}
