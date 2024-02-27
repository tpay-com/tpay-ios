//
//  Copyright © 2024 Tpay. All rights reserved.
//

extension Domain {
    
    typealias ChannelId = String
    
    struct PaymentChannel {
        
        // MARK: - Properties
        
        let id: ChannelId
        let associatedGroupId: BankGroupId
        
        let amountConstraints: [AmountConstraint]
        
        // MARK: - Initializers
    
        init(id: ChannelId, associatedGroupId: BankGroupId, amountConstraints: [AmountConstraint] = []) {
            self.id = id
            self.associatedGroupId = associatedGroupId
            self.amountConstraints = amountConstraints
        }
    }
}
