//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ConfigurationSetter {
    
    // MARK: - API
    
    func set(merchant: Merchant)
    func set(merchantDetailsProvider: MerchantDetailsProvider)
    func set(paymentMethods: [PaymentMethod])
    func set(preferredLanguage: Language)
    func set(supportedLanguages: [Language])
}
