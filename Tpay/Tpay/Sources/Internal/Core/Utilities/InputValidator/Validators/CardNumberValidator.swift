//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CardNumberValidator: InputValidator {
    
    // MARK: - Properties
    
    private(set) var brand: CardNumberDetectionModels.CreditCard.Brand?
    
    private let error: InputValidationError
    
    // MARK: - Initializers
    
    init(error: InputValidationError) {
        self.error = error
    }
    
    // MARK: - API
    
    func validate(_ input: String) -> InputValidationResult {
        if input.matches(Constants.mastercardRegex) {
            brand = .mastercard
            return .success
        } else if input.matches(Constants.visaRegex) {
            brand = .visa
            return .success
        } else if input.matches(Constants.cardNumberRegex) {
            brand = .other
            return .failure(error: error) // any format other than visa/mc should be marked as invalid (according to the https://kipsa.atlassian.net/browse/QA-806)
        } else {
            brand = nil
            return .failure(error: error)
        }
    }
}

private extension CardNumberValidator {
    
    enum Constants {
        
        // MARK: - Properties
        
        static let mastercardRegex: String = #"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"#
        static let visaRegex: String = #"^4([0-9]{12}|[0-9]{15}|[0-9]{18})$"#
        static let cardNumberRegex: String = #"(?:\d[ -]*?){13,16}"#
    }
}
