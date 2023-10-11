//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain {
    
    struct OngoingTokenization {
        
        // MARK: - Properties
        
        let result: Result
        let requestId: String
        let tokenizationId: String
        
        let continueUrl: URL?
    }
}
