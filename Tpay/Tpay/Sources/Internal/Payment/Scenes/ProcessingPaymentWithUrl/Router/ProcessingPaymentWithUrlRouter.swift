//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ProcessingPaymentWithUrlRouter: AnyObject {

    // MARK: - Events

    var onSuccess: Observable<Void> { get }
    var onError: Observable<Void> { get }
    var onGoBack: Observable<Void> { get }
}

extension ProcessingPaymentWithUrlRouter {

    // MARK: - API

    func invokeOnSuccess() {
        onSuccess.on(.next(()))
    }

    func invokeOnError() {
        onError.on(.next(()))
    }

    func invokeOnGoBack() {
        onGoBack.on(.next(()))
    }
}
