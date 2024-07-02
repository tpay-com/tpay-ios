//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol PayWithPayPoViewModel {
    
    // MARK: - Events
    
    var payerNameState: Observable<InputContentState> { get }
    var payerEmailState: Observable<InputContentState> { get }
    var payerStreetAdressState: Observable<InputContentState> { get }
    var payerPostalCodeAdressState: Observable<InputContentState> { get }
    var payerCityAdressState: Observable<InputContentState> { get }
    
    var isProcessing: Observable<Bool> { get }

    // MARK: - Properties
    
    var transaction: Domain.Transaction { get }
    var merchantDetails: Domain.MerchantDetails { get }
    
    var payerName: String { get }
    var payerEmail: String { get }
    var payerStreetAdress: String { get }
    var payerPostalCodeAdress: String { get }
    var payerCityAdress: String { get }
    
    // MARK: - API
    
    func set(payerName: String)
    func set(payerEmail: String)
    func set(payerStreetAdress: String)
    func set(payerPostalCodeAdress: String)
    func set(payerCityAdress: String)
    
    func invokePayment()
}
