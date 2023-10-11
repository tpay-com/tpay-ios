//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum InputValidationResult: Hashable {
    
    // MARK: - Cases
    
    case success
    case failure(error: InputValidationError)
    
    // MARK: - Getters
    
    var error: InputValidationError? {
        switch self {
        case .success: return nil
        case let .failure(error: error): return error
        }
    }
}
