//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension NewTransactionDTO {
    
    struct Callbacks: Encodable {
        
        // MARK: - Properties
        
        let successUrl: URL
        let errorURL: URL
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            var payerUrls = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .payerUrls)
            try payerUrls.encode(successUrl, forKey: .success)
            try payerUrls.encode(errorURL, forKey: .error)
        }
    }
}

private extension NewTransactionDTO.Callbacks {
    
    enum NestedCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case success
        case error
    }
    
    enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case payerUrls
    }
}
