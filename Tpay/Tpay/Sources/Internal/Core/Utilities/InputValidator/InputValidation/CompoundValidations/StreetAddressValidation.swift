//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class StreetAddressValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidLength: InputValidationError, invalidStreetAddress: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: MinLengthValidator(with: 3, error: invalidStreetAddress)))
        add(InputValidation(of: .empty, using: MaxLengthValidator(with: 255, error: invalidStreetAddress)))
        add(InputValidation(of: .empty, using: AlphanumericValidator(error: invalidStreetAddress)))
        add(InputValidation(of: .empty, using: NoEmojisValidator(error: invalidStreetAddress)))
    }
}
