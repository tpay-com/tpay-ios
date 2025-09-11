//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultCardEncryptor: CardEncryptor {
    
    // MARK: - Properties
    
    private let encryptor: Encryptor
    private let serializer: CardDataSerializer
    
    // MARK: - Initializers
    
    convenience init?(using resolver: ServiceResolver) {
        do {
            try self.init(
                encryptor: DefaultEncryptor(using: resolver),
                serializer: DefaultCardDataSerializer(using: resolver)
            )
        } catch {
            return nil
        }
    }
    
    init(encryptor: Encryptor, serializer: CardDataSerializer) {
        self.encryptor = encryptor
        self.serializer = serializer
    }
    
    // MARK: - API
    
    func encrypt(card: Domain.Card) throws -> EncryptedData {
        let cardData = try serializer.serialize(card: card)
        return try encryptor.encrypt(message: cardData)
    }
}
