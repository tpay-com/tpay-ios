//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain.Card {
    
    struct ExpiryDate {
        
        // MARK: - Properties
        
        let month: Int
        let year: Int
    }
}

extension Domain.Card.ExpiryDate {
    
    static func make(from string: String) -> Self? {
        guard string.count == 5 else {
            return nil
        }
        
        let components = string.components(separatedBy: "/")
        guard components.count == 2 else {
            return nil
        }
        
        guard let month = Int(components[0]), let year = Int(components[1]) else {
            return nil
        }
        
        switch (month, year) {
        case (1...12, 0...99):
            return Self(month: month, year: year)
        default:
            return nil
        }
    }
}
