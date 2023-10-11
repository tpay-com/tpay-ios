//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol Encryptor {
    
    // MARK: - API
    
    func encrypt(message: Data) throws -> EncryptedData
}
