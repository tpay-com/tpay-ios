//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Security

final class DefaultEncryptor: Encryptor {
    private enum DefaultEncryptorError: Error {
        case missingPublicKey 
    }
    
    // MARK: - Properties
    
    private let publicKey: SecKey
    
    // MARK: - Initializers
   
    convenience init(using resolver: ServiceResolver) throws {
        try self.init(configurationProvider: resolver.resolve())
    }
    
    convenience init(configurationProvider: ConfigurationProvider) throws {
        guard let publicKey = configurationProvider.merchant?.cardsConfiguration?.publicKey else {
            throw DefaultEncryptorError.missingPublicKey
        }
        self.init(publicKey: publicKey)
    }
    
    init(publicKey: SecKey) {
        self.publicKey = publicKey
    }
    
    // MARK: - API
    
    func encrypt(message: Data) throws -> EncryptedData {
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, Self.supportedKeyAlgorithm) else {
            throw EncryptorError.unsupportedEncryptionAlgorithm
        }
        
        guard let encryptedMessage = SecKeyCreateEncryptedData(publicKey, Self.supportedKeyAlgorithm, message as CFData, nil) as? Data else {
            throw EncryptorError.cannotEncryptData
        }
        
        return .init(data: encryptedMessage)
    }
}

private extension DefaultEncryptor {
    
    // MARK: - Properties
    
    static let supportedKeyAlgorithm = SecKeyAlgorithm.rsaEncryptionPKCS1
}
