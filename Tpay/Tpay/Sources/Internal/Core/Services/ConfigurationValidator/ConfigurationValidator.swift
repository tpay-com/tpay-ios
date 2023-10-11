//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ConfigurationValidator {
    
    // MARK: - API
    
    func checkProvidedConfiguration() -> ConfigurationCheckResult
}
