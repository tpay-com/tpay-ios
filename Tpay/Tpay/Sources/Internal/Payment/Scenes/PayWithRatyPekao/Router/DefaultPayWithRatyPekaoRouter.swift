//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class DefaultPayWithRatyPekaoRouter: PayWithRatyPekaoRouter {
    
    // MARK: - Properties
    
    let onTransactionCreated = Observable<Domain.OngoingTransaction>()
    let onError = Observable<Error>()
}
