//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `ConfigurationCheckResult` enum represents the outcome of a configuration check, indicating whether the configuration is valid or invalid, along with relevant error information.

public enum ConfigurationCheckResult: Equatable {

    // MARK: - Cases
    
    /// Represents a valid configuration.

    case valid
    
    /// Represents an invalid configuration along with an associated error.

    case invalid(MerchantConfigurationError)
}
