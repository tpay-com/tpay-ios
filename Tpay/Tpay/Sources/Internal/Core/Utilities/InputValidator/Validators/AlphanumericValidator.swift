//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

final class AlphanumericValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        let specialCharacters = input.rangeOfCharacter(from: CharacterSet.specialcharacters)
        return specialCharacters == nil ? .success : .failure(error: error)
    }
    
}
