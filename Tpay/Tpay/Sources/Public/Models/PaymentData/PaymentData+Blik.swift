//
// Copyright (c) 2022 Tpay. All rights reserved.
//

extension PaymentData {

    public struct Blik {

        // MARK: - Properties

        let blikToken: BlikToken?
        let aliases: RegisteredBlikAlias?
        
        // MARK: - Initialization
        
        public init(blikToken: BlikToken?, aliases: RegisteredBlikAlias?) {
            self.blikToken = blikToken
            self.aliases = aliases
        }
    }
}
