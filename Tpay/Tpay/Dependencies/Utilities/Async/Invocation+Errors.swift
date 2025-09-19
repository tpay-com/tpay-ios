//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Invocation {
    
    enum Errors: LocalizedError {
        
        // MARK: - Cases
        
        case completedWithoutResults
        
        // MARK: - Getters
        
        var errorDescription: String? {
            "Operation was completed without results"
        }
        
    }
    
}
