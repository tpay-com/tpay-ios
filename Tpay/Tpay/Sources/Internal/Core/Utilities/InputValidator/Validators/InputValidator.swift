//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol InputValidator {
        
    associatedtype InputType
    
    // MARK: - API
    
    func validate(_ input: InputType) -> InputValidationResult
}
