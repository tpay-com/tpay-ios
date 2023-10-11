//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct InputValidation<InputType: Equatable> {
    
    // MARK: - Properties
    
    private(set) var input: InputType
    private(set) var result: Result = .notDetermined
    
    private let validation: (InputType) -> InputValidationResult
    
    // MARK: - Initializers
    
    init<ValidatorType: InputValidator>(of value: InputType, using validator: ValidatorType) where ValidatorType.InputType == InputType {
        input = value
        validation = validator.validate
    }
    
    // MARK: - API
    
    mutating func validate(input: InputType) {
        guard self.input != input else { return }
        
        self.input = input
        
        let validationResult = validation(input)
        
        switch (result, validationResult) {
        case (.notDetermined, .success): result = .valid
        case let (.valid, .failure(error)): result = .invalid(error)
        case (.invalid, .success): result = .valid
        default: break
        }
    }
    
    mutating func forceValidation() {
        switch validation(input) {
        case .success: result = .valid
        case let .failure(error): result = .invalid(error)
        }
    }
}
