//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PayWithAmbiguousBlikAliasesViewModel: AnyObject {
    
    // MARK: - Events
    
    var isProcessing: Observable<Bool> { get }
    var isValid: Observable<Bool> { get }
    
    // MARK: - Properties
    
    var blikAliases: [Domain.Blik.OneClick.Alias] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func select(blikAlias: Domain.Blik.OneClick.Alias)
    
    func navigateToBlikCode()
    func invokePayment()
}
