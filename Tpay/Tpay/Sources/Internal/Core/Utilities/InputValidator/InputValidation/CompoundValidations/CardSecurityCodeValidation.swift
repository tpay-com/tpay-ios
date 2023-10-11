//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CardSecurityCodeValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidCardSecurityCode: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: CardSecurityCodeValidator(error: invalidCardSecurityCode)))
    }
}
