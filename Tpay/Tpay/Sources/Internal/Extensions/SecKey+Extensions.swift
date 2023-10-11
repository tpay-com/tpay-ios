//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation
import Security

extension SecKey {
    
    static func decodePublicKey(from base64Encoded: String) -> SecKey? {
        guard let data = Data(base64Encoded: base64Encoded, options: [.ignoreUnknownCharacters]),
              let derString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return makePublicKey(from: derString)
    }
    
    // MARK: - Private
    
    private static func makePublicKey(from derString: String) -> SecKey? {
        let key = preprocess(keyString: derString)
        guard let data = Data(base64Encoded: key) else {
            return nil
        }
        return makePublicKey(from: data)
    }
    
    private static func makePublicKey(from data: Data) -> SecKey? {
        let attributes: NSDictionary = [kSecAttrKeyType: kSecAttrKeyTypeRSA,
                                       kSecAttrKeyClass: kSecAttrKeyClassPublic]
        return SecKeyCreateWithData(data as NSData, attributes, nil)
    }
    
    private static func preprocess(keyString: String) -> String {
        keyString
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "" )
    }
}
