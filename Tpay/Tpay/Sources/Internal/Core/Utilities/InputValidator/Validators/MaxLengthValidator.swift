//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

final class MaxLengthValidator<InputType: Collection>: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    private let value: Int
    
    // MARK: - Initializers
    
    init(with value: Int, error: InputValidationError) {
        self.value = value
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: InputType) -> InputValidationResult {
        switch input.count <= value {
        case true: return .success
        case false: return .failure(error: error)
        }
    }
}
