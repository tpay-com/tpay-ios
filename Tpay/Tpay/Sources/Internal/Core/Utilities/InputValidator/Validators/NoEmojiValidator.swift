//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class NoEmojisValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        let specialCharacters = input.rangeOfCharacter(from: CharacterSet.emojis)
        return specialCharacters == nil ? .success : .failure(error: error)
    }
}
