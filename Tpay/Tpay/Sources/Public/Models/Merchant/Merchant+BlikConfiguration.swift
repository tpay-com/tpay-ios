//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension Merchant {
    
/// The `BlikConfiguration` struct encompasses configuration settings related to BLIK payments, including the option to specify a BLIK alias to be registered during a standard BLIK transaction to allow a payer to perform BLIK OneClick payments during future transactions.
    
    public struct BlikConfiguration: Equatable {
        
        // MARK: - Properties
        
        let aliasToBeRegistered: NotRegisteredBlikAlias?
        
        // MARK: - Initializer
        
        public init(aliasToBeRegistered: NotRegisteredBlikAlias? = nil) {
            self.aliasToBeRegistered = aliasToBeRegistered
        }
    }
}
