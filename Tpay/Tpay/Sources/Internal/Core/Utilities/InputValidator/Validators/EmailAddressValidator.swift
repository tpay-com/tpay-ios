//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class EmailAddressValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        let expression = "^[\\w!#$%&’*+/=?`{|}~^-]+(?:\\.[\\w!#$%&’*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$"

        switch NSPredicate(format: "SELF MATCHES[c] %@", expression).evaluate(with: input) {
        case true: return .success
        case false: return .failure(error: error)
        }
    }
}
