//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CardExpiryDateValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidCardExpiryDate: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: CardExpiryDateValidator(error: invalidCardExpiryDate)))
    }
}
