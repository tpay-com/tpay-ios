//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `ModuleConfigurationError` enum encompasses different errors related to module configuration settings.

public enum ModuleConfigurationError: ModuleError {
    
    // MARK: - Cases
    
    case supportedLanguagesEmpty
    case preferredLanguageNotInSupportedLanguages
}
