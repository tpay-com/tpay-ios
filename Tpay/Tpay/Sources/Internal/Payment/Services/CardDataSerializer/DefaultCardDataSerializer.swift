//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultCardDataSerializer: CardDataSerializer {
    
    // MARK: - Properties
    
    private let merchantDomain: String
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchant = configurationProvider.merchant else {
            preconditionFailure("Merchant is not configured")
        }
        self.init(merchantDomain: merchant.domain)
    }
    
    init(merchantDomain: String) {
        self.merchantDomain = merchantDomain
    }
    
    // MARK: - API
    
    func serialize(card: Domain.Card) throws -> Data {
        try card.toString(with: merchantDomain)
            .data(using: .utf8)
            .value(orThrow: CardDataSerializerError.cannotSerialize)
    }
}

private extension Domain.Card {
    
    func toString(with domain: String) -> String {
        let components: [String] = [number, expiryDate.toString(), securityCode, domain]
        let separator = "|"
        return String(components.joined(separator: separator))
    }
}

private extension Domain.Card.ExpiryDate {
    
    func toString() -> String {
        let components: [String] = [String(format: "%02d", month), String(format: "%02d", year)]
        let separator = "/"
        return String(components.joined(separator: separator))
    }
}
