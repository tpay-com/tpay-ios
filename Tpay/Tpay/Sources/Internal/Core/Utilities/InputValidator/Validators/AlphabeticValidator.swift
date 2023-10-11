//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class AlphabeticValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        let decimalDigits = input.rangeOfCharacter(from: .decimalDigits)
        let specialCharacters = input.rangeOfCharacter(from: CharacterSet.specialcharacters)
        return (decimalDigits == nil && specialCharacters == nil) ? .success : .failure(error: error)
    }
    
}
