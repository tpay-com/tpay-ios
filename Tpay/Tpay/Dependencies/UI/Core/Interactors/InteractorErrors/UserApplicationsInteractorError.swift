//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

enum UserApplicationsInteractorError: LocalizedError {
    
    // MARK: - Cases
    
    case cannotOpenApplication
    case notSupportedApplication
    
    // MARK: - Getters
    
    var errorDescription: String? {
        switch self {
        case .cannotOpenApplication: return "Cannot open application."
        case .notSupportedApplication: return "Application is not supported."
        }
    }
    
}
