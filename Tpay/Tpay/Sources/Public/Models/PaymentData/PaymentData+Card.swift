//
// Copyright (c) 2022 Tpay. All rights reserved.
//

extension PaymentData {

    public struct Card {

        // MARK: - Properties

        let card: CardDetails?
        let token: CardToken?
    }
}

extension PaymentData.Card {

    public struct CardDetails {

        // MARK: - Properties

        let number: String
        let expiryDate: ExpiryDate
        let securityCode: String
        let shouldSave: Bool
    }
}

extension PaymentData.Card.CardDetails {

    public struct ExpiryDate {

        // MARK: - Properties

        let month: Int
        let year: Int
    }
}
