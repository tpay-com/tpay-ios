//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

protocol PayWithRatyPekaoRouter: AnyObject {
    
    // MARK: - Events
    
    var onTransactionCreated: Observable<Domain.OngoingTransaction> { get }
    var onError: Observable<Error> { get }
}

extension PayWithRatyPekaoRouter {
    
    // MARK: - API
    
    func invokeOnTransactionCreated(with: Domain.OngoingTransaction) {
        onTransactionCreated.on(.next(with))
    }
    
    func invokeOnError(with: Error) {
        onError.on(.next(with))
    }
}
