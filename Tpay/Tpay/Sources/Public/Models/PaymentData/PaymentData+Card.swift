//
// Copyright (c) 2022 Tpay. All rights reserved.
//

extension PaymentData {

    public struct Card {
        
        // MARK: - Properties
        
        let card: CardDetails?
        let token: CardToken?
        
        // MARK: - Initializers
        
        public init(card: CardDetails?, token: CardToken?) {
            self.card = card
            self.token = token
        }
    }
}

extension PaymentData.Card {

    public struct CardDetails {
        
        // MARK: - Properties

        let number: String
        let expiryDate: ExpiryDate
        let securityCode: String
        let shouldSave: Bool
        
        // MARK: - Initializers

        public init(number: String, expiryDate: ExpiryDate, securityCode: String, shouldSave: Bool) {
            self.number = number
            self.expiryDate = expiryDate
            self.securityCode = securityCode
            self.shouldSave = shouldSave
        }
    }
}

extension PaymentData.Card.CardDetails {

    public struct ExpiryDate {
        
        // MARK: - Properties

        let month: Int
        let year: Int
        
        // MARK: - Initializers
        
        public init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }
    }
}
