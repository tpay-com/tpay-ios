//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol AddCardRouter: AnyObject {
    
    // MARK: - Events
    
    var onCardScan: Observable<Void> { get }
    var onSuccess: Observable<Domain.OngoingTokenization> { get }
    var onError: Observable<Error> { get }
    var closeAction: Observable<Void> { get }
    
    // MARK: - API
    
    func invokeOnCardScan()
    func invokeOnSuccess(_ transaction: Domain.OngoingTokenization)
    func invokeOnError(with error: Error)
    func close()
}
