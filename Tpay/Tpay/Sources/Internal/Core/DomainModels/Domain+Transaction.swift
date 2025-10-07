//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Domain {
    
    struct Transaction {

        // MARK: - Properties

        let paymentInfo: PaymentInfo
        let payer: Payer
        let notification: Notification?
    }
}
