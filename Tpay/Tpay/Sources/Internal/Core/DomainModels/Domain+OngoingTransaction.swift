//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain {
    
    struct OngoingTransaction {
        
        // MARK: - Properties
        
        let transactionId: String
        let status: Status
        let notification: Notification?
        
        let continueUrl: URL?
        let paymentErrors: [PaymentError]?
    }
}
