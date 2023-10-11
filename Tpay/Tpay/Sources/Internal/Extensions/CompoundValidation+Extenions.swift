//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension EmailValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidEmailAddress: .invalidEmailAddress)
    }
}

extension NameValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidLength: .invalidLength, invalidName: .invalidName)
    }
}

extension CardNumberValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidCardNumber: .invalidCardNumber)
    }
}

extension CardExpiryDateValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidCardExpiryDate: .invalidCardExpiryDate)
    }
}

extension CardSecurityCodeValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidCardSecurityCode: .invalidCardSecurityCode)
    }
}

extension BlikCodeValidation {
    
    convenience init() {
        self.init(requiredValue: .requiredValue, invalidBlikCode: .invalidBlikCode)
    }
}
