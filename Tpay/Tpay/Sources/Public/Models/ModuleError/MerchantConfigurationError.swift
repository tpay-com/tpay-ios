//
//  Copyright © 2023 Tpay. All rights reserved.
//

/// The `MerchantConfigurationError` enum represents various errors related to merchant configuration settings.
///
///  This enum also offers a `multiple` case that can contain an array of multiple errors if needed.

public enum MerchantConfigurationError: ModuleError, Equatable {
    
    // MARK: - Cases
    
    case paymentMethodsEmpty
    case merchantNotProvided
    case merchantDetailsNotProvided
    case cardsConfigurationNotProvided
    case applePayConfigurationNotProvided
    
    case multiple([MerchantConfigurationError])
}
