//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class EmailValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidEmailAddress: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: EmailAddressValidator(error: invalidEmailAddress)))
    }
}
