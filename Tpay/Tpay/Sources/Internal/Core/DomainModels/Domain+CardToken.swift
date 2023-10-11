//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain {
    
    struct CardToken: Equatable {
        
        // MARK: - Properties
        
        let token: String
        let cardTail: String
        let brand: Brand
    }
}
