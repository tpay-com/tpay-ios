//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension PayerContext {
    
    var hasTokenizedCards: Bool { tokenizedCards.isNotEmpty }
    var hasRegisteredBlikAlias: Bool { registeredBlikAlias != nil }
    
    var tokenizedCards: [CardToken] {
        automaticPaymentMethods?.tokenizedCards ?? []
    }
    
    var registeredBlikAlias: RegisteredBlikAlias? {
        automaticPaymentMethods?.registeredBlikAlias
    }
}
