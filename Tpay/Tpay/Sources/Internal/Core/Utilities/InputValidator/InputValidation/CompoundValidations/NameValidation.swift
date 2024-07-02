//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class NameValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidLength: InputValidationError, invalidName: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: MinLengthValidator(with: 3, error: invalidLength)))
        add(InputValidation(of: .empty, using: MaxLengthValidator(with: 255, error: invalidLength)))
        add(InputValidation(of: .empty, using: AlphanumericValidator(error: invalidName)))
        add(InputValidation(of: .empty, using: NoEmojisValidator(error: invalidName)))
    }
}
