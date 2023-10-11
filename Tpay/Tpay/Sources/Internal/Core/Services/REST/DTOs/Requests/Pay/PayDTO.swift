//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct PayDTO: Encodable {
    
    // MARK: - Properties
    
    let groupId: Int
    let method: Method?

    let applePayPaymentData: ApplePayPaymentData?
    let blikPaymentData: BlikPaymentData?
    let cardPaymentData: CardPaymentData?
    
    let recursive: Recursive?
    
    // MARK: - Initializers
    
    init(groupId: BankGroupId,
         method: Method? = nil,
         applePayPaymentData: ApplePayPaymentData? = nil,
         blikPaymentData: BlikPaymentData? = nil,
         cardPaymentData: CardPaymentData? = nil,
         recursive: Recursive? = nil) {
        self.groupId = Int(groupId.rawValue) ?? -1
        self.method = method
        self.applePayPaymentData = applePayPaymentData
        self.blikPaymentData = blikPaymentData
        self.cardPaymentData = cardPaymentData
        self.recursive = recursive
    }
}
