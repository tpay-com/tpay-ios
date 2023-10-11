//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension InputValidationError {

    static var requiredValue: InputValidationError { InputValidationError(description: Strings.fieldIsRequired) }
    static var invalidLength: InputValidationError { InputValidationError(description: Strings.invalidLength) }
    static var invalidEmailAddress: InputValidationError { InputValidationError(description: Strings.emailIsInvalid) }
    static var invalidName: InputValidationError { InputValidationError(description: Strings.nameIsInvalid) }
    
    static var invalidCardNumber: InputValidationError { InputValidationError(description: Strings.cardNumberIsInvalid) }
    static var invalidCardExpiryDate: InputValidationError { InputValidationError(description: Strings.cardExpiryDateIsInvalid) }
    static var invalidCardSecurityCode: InputValidationError { InputValidationError(description: Strings.cardSecurityCodeIsInvalid) }
    static var invalidBlikCode: InputValidationError { InputValidationError(description: Strings.blikCodeIsInvalid) }

}
