//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultFailureRouter: FailureRouter {
    
    // MARK: - Events

    let onPrimaryAction = Observable<Void>()
    let onCancel = Observable<Void>()
}
