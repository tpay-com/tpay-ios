//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithBlikCodeViewModel: AnyObject {
    
    // MARK: - Events
    
    var blikCodeState: Observable<InputContentState> { get }
    var isProcessing: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var transaction: Domain.Transaction { get }
    var isNavigationToOneClickEnabled: Bool { get }
    var shouldAllowAliasRegistration: Bool { get }
    
    // MARK: - API
    
    func set(blikCode: String)
    
    func set(shouldRegisterAlias: Bool)
    func set(aliasLabel: String?)

    func navigateBackToOneClick()
    func invokePayment()
}
