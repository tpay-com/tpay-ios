//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class CardNumberValidation: CompoundValidation<String> {
    
    // MARK: - Properties
    
    var brand: CardNumberDetectionModels.CreditCard.Brand? { cardNumberValidator.brand }
    
    private let cardNumberValidator: CardNumberValidator
    
    // MARK: - Initializers
    
    init(requiredValue: InputValidationError, invalidCardNumber: InputValidationError) {
        cardNumberValidator = CardNumberValidator(error: invalidCardNumber)
        
        super.init(input: .empty)
        
        add(InputValidation(of: .empty, using: NotEmptyValidator(error: requiredValue)))
        add(InputValidation(of: .empty, using: cardNumberValidator))
    }
}
