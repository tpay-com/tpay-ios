//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class NotEmptyValidator<InputType: Collection>: InputValidator {
  
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: InputType) -> InputValidationResult {
        switch input.isEmpty {
        case true: return .failure(error: error)
        case false: return .success
        }
    }
}
