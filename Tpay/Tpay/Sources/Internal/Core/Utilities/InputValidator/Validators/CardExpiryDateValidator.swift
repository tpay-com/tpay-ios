//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CardExpiryDateValidator: InputValidator {
    
    // MARK: - Properties
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        if input.matches(Constants.expiryDateRegex) {
            return .success
        } else {
            return .failure(error: error)
        }
    }
}

private extension CardExpiryDateValidator {
    
    enum Constants {
        
        // MARK: - Properties
        
        static let expiryDateRegex: String = #"^(0[1-9]|1[0-2])\//?([0-9]{4}|[0-9]{2})$"#
    }
}
