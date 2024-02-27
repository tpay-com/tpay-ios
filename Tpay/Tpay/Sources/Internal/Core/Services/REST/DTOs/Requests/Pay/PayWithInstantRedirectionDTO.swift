//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct PayWithInstantRedirectionDTO: Encodable {
    
    // MARK: - Properties
    
    let channelId: Int
    let method: Method?
    
    let applePayPaymentData: ApplePayPaymentData?
    let blikPaymentData: BlikPaymentData?
    let cardPaymentData: CardPaymentData?
    
    let recursive: Recursive?
    
    // MARK: - Initializers
    
    init(channelId: String,
         method: Method? = nil,
         applePayPaymentData: ApplePayPaymentData? = nil,
         blikPaymentData: BlikPaymentData? = nil,
         cardPaymentData: CardPaymentData? = nil,
         recursive: Recursive? = nil) {
        self.channelId = Int(channelId) ?? -1
        self.method = method
        self.applePayPaymentData = applePayPaymentData
        self.blikPaymentData = blikPaymentData
        self.cardPaymentData = cardPaymentData
        self.recursive = recursive
    }
}
