//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain.Blik {
    
    struct Regular {
        
        // MARK: - Properties
        
        let token: BlikToken?
        let alias: Alias?
    }
}

extension Domain.Blik.Regular {
    
    struct Alias {
        
        // MARK: - Properties
        
        let value: String
        let type: Domain.Blik.AliasType
        private(set) var label: String?
        
        mutating func labeled(with string: String) -> Self {
            self.label = string
            return self
        }
    }
}
