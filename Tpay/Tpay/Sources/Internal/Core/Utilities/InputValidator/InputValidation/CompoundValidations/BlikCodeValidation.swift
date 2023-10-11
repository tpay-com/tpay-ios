//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class BlikCodeValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidBlikCode: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: BlikCodeValidator(error: invalidBlikCode)))
    }
}
