//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension NewTransactionDTO {
    
    struct Callbacks: Encodable {
        
        // MARK: - Properties
        
        let successUrl: URL
        let errorUrl: URL
        
        let notificationUrl: URL?
        
        // MARK: - Encodable
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            var payerUrls = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .payerUrls)
            try payerUrls.encode(successUrl, forKey: .success)
            try payerUrls.encode(errorUrl, forKey: .error)
            
            var notification = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .notification)
            try notification.encode(notificationUrl, forKey: .url)
        }
    }
}

private extension NewTransactionDTO.Callbacks {
    
    enum NestedCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case success
        case error
        
        case url
    }
    
    enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case payerUrls
        case notification
    }
}
