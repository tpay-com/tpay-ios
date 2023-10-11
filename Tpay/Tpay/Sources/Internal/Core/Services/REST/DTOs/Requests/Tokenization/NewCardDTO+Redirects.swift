//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension NewCardDTO {
    
    struct Redirects: Encodable {
        
        // MARK: - Properties
        
        let successUrl: URL
        let errorURL: URL
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(successUrl, forKey: .success)
            try container.encode(errorURL, forKey: .error)
        }
    }
}

private extension NewCardDTO.Redirects {
    
    enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case success
        case error
    }
}
