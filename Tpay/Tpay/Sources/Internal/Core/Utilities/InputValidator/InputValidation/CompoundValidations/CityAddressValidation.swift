//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class CityAddressValidation: CompoundValidation<String> {
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidLength: InputValidationError, invalidCityAddress: InputValidationError) {
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: MinLengthValidator(with: 1, error: invalidCityAddress)))
        add(InputValidation(of: .empty, using: MaxLengthValidator(with: 255, error: invalidCityAddress)))
        add(InputValidation(of: .empty, using: AlphanumericValidator(error: invalidCityAddress)))
        add(InputValidation(of: .empty, using: NoEmojisValidator(error: invalidCityAddress)))
    }
}
