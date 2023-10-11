//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ConfigurationProvider {
    
    // MARK: - Properties

    var merchant: Merchant? { get }
    var merchantDetailsProvider: MerchantDetailsProvider? { get }
    var paymentMethods: [PaymentMethod] { get }
    var preferredLanguage: Language { get }
    var supportedLanguages: [Language] { get }
}
