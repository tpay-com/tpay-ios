//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class BlikCodeValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        let expression = "^[0-9]{6}$"

        switch NSPredicate(format: "SELF MATCHES[c] %@", expression).evaluate(with: input) {
        case true: return .success
        case false: return .failure(error: error)
        }
    }
}
