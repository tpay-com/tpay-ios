//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CardEncryptor {
    
    // MARK: - API
    
    func encrypt(card: Domain.Card) throws -> EncryptedData
}
