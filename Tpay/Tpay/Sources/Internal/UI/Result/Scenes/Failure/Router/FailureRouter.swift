//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol FailureRouter: AnyObject {
    
    // MARK: - Events
    
    var onPrimaryAction: Observable<Void> { get }
    var onCancel: Observable<Void> { get }
}

extension FailureRouter {
    
    // MARK: - API
    
    func invokeOnPrimaryAction() {
        onPrimaryAction.on(.next(()))
    }
    
    func invokeOnCancel() {
        onCancel.on(.next(()))
    }
}
