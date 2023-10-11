//
//  Copyright © 2022 Tpay. All rights reserved.
//

class CompoundValidation<InputType: Equatable> {
    
    // MARK: - Properties
    
    var isValid: Bool { result == .valid }
    var result: InputValidation<InputType>.Result { calculateResult() }
    
    private(set) var input: InputType
    private var validations: [InputValidation<InputType>] = []
    
    // MARK: - Initializers
    
    init(input: InputType) {
        self.input = input
    }
    
    // MARK: - API
    
    final func validate(_ input: InputType) {
        self.input = input
        
        for index in 0 ..< validations.count {
            validations[index].validate(input: input)
        }
        
        if forceValidation(for: input) {
            forceValidation()
        }
    }
    
    final func forceValidation() {
        for index in 0 ..< validations.count {
            validations[index].forceValidation()
        }
    }
    
    final func add(_ validation: InputValidation<InputType>) {
        validations.append(validation)
    }
    
    func forceValidation(for input: InputType) -> Bool { false }
    
    // MARK: - Private
    
    private func calculateResult() -> InputValidation<InputType>.Result {
        var containsNotDetermined = false
        
        for validation in validations {
            switch validation.result {
            case let .invalid(error): return .invalid(error)
            case .notDetermined: containsNotDetermined = true
            case .valid: break
            }
        }
        
        switch containsNotDetermined {
        case true: return .notDetermined
        case false: return .valid
        }
    }
    
}
