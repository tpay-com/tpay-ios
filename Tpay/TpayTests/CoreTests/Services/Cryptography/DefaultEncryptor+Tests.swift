//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
import Security
@testable import Tpay
import XCTest

final class DefaultEncryptor_Tests: XCTestCase {
        
    // MARK: - Tests
    
    func test_Encrypt() throws {
        guard let publicKey = generateRandomCryptographyKey(type: .rsa, size: 1_024) else {
            throw TestError.noPublicKey
        }
        let sut = DefaultEncryptor(publicKey: publicKey)
        let data = Stub.cardData
        
        let encryptedData = try sut.encrypt(message: data)
        expect(encryptedData.data.base64EncodedString()).notTo(beEmpty())
    }
    
    func test_InvalidKeyAlgorithm() throws {
        guard let ecPublicKey = generateRandomCryptographyKey(type: .ec, size: 256) else {
            throw TestError.noPublicKey
        }
        
        let sut = DefaultEncryptor(publicKey: ecPublicKey)
        let data = Stub.cardData
        
        expect(try sut.encrypt(message: data)).to(throwError(EncryptorError.unsupportedEncryptionAlgorithm))
    }
    
    // MARK: - Private
    
    private func generateRandomCryptographyKey(type: KeyType, size: Int) -> SecKey? {
        let attributes: [String: Any] = [kSecAttrKeyType as String: type.attribute,
                                         kSecAttrKeySizeInBits as String: size]
        let ecPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, nil)
        guard let ecPrivateKey = ecPrivateKey else {
            return nil
        }
        return SecKeyCopyPublicKey(ecPrivateKey)
    }
}

private extension DefaultEncryptor_Tests {
    
    enum Stub {
        
        // MARK: - Properties

        static let cardData = "1111111111111111|11/11|111|https://merchantapp.online".data(using: .utf8).value(or: .init())
    }
    
    enum TestError: Error {
        
        // MARK: - Cases
        
        case noPublicKey
    }
    
    enum KeyType {
        
        // MARK: - Cases
        
        case rsa
        case ec
        
        // MARK: - Properties
        
        var attribute: CFString {
            switch self {
            case .rsa:
                return kSecAttrKeyTypeRSA
            case .ec:
                return kSecAttrKeyTypeEC
            }
        }
    }
}
