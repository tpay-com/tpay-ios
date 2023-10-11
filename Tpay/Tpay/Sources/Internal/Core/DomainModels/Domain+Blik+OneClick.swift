//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain.Blik {
    
    struct OneClick {
        
        // MARK: - Properties
        
        let alias: Alias
    }
}

extension Domain.Blik.OneClick {
    
    struct Alias {
        
        // MARK: - Properties
        
        let value: String
        let type: Domain.Blik.AliasType
        private (set) var application: Application?
        
        mutating func specified(using application: Application) -> Self {
            self.application = application
            return self
        }
    }
}

extension Domain.Blik.OneClick.Alias {
    
    struct Application {
        
        // MARK: - Properties
        
        let name: String
        let key: String
    }
}
