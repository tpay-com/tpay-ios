//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum InputContentState: Hashable {
    
    // MARK: - Cases
    
    case notDetermined
    case valid
    case invalid(InputValidationError)
    
    // MARK: - Properties
    
    var isValid: Bool { self == .valid }
    
    // MARK: - Initializers
    
    init(_ error: InputValidationError) {
        self = .invalid(error)
    }
    
    init<InputType>(_ validationResult: InputValidation<InputType>.Result) {
        switch validationResult {
        case .notDetermined: self = .notDetermined
        case .valid: self = .valid
        case let .invalid(error): self = .invalid(error)
        }
    }
    
    // MARK: - API
    
    func merged(with other: InputContentState) -> InputContentState {
        switch (self, other) {
        case (.valid, .valid): return self
        case (.invalid, _): return self
        case (_, .invalid): return other
        default: return .notDetermined
        }
    }
    
}
