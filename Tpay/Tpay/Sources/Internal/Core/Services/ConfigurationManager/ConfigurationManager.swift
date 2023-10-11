//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ConfigurationManager: ConfigurationProvider & ConfigurationSetter {
    
    // MARK: - API
    
    func clear()
}
