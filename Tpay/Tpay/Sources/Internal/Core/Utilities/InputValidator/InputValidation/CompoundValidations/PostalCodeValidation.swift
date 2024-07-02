//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class PostalCodeValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidPostalCode: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: PostalCodeValidator(error: invalidPostalCode)))
    }
}
