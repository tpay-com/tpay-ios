//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain.OngoingTokenization {
    
    enum Result {
        
        // MARK: - Cases
        
        case success
        case pending
        case actionRequired
        case failed
    }
}
