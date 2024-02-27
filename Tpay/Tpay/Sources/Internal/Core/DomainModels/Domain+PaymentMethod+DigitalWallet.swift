//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Domain.PaymentMethod {
    
    struct DigitalWallet: Equatable, Hashable {
        
        // MARK: - Properties
        
        let id: String
        let kind: Kind
        let name: String
        let imageUrl: URL?
        
        // MARK: - Initializers
        
        init(id: String, kind: Kind, name: String, imageUrl: URL?) {
            self.id = id
            self.kind = kind
            self.name = name
            self.imageUrl = imageUrl
        }
        
        init(kind: Kind) {
            self.kind = kind
            
            id = .empty
            name = .empty
            imageUrl = nil
        }
    }
}

extension Domain.PaymentMethod.DigitalWallet {
    
    // MARK: - Properties
    
    static let any = Domain.PaymentMethod.DigitalWallet(id: .empty, kind: .unknown, name: .empty, imageUrl: nil)
}
