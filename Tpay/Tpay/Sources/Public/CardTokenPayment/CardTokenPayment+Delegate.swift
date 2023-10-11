//
//  Copyright © 2023 Tpay. All rights reserved.
//

@_documentation(visibility: internal)
public protocol CardTokenPaymentDelegate: AnyObject {
    
    // MARK: - API
    
    func onCardTokenPaymentCompleted(transactionId: TransactionId)
    func onCardTokenPaymentCancelled(transactionId: TransactionId)
    func onCardTokenErrorOccured(error: ModuleError)
}
