//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultURLEncoder: ObjectEncoder {
    
    // MARK: - Properties
    
    private let dictionaryEncoder: DictionaryEncoder
    
    // MARK: - Initializers
    
    init(using encoder: DictionaryEncoder) {
        dictionaryEncoder = encoder
    }
    
    // MARK: - API
    
    func encode<ValueType: Encodable>(_ object: ValueType) throws -> Data {
        let dictionary = try dictionaryEncoder.encode(object)
        
        guard let data = dataFrom(dictionary: dictionary) else { throw Error.unconvertibleString }
        
        return data
    }
    
    // MARK: - Private
    
    private func dataFrom(dictionary: [String: Any]) -> Data? {
        let dataString = query(parameters: dictionary)
        return dataString.data(using: .utf8)
    }
    
    private func query(parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys {
            if let value = parameters[key] {
                components.append(contentsOf: queryComponents(key, value))
            }
        }
        
        var keyValuePairs = [String]()
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        for (key, value) in components {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                keyValuePairs.append(key + "=" + encodedValue)
            }
        }
        
        return keyValuePairs.joined(separator: "&")
    }
    
    private func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components.append(contentsOf: queryComponents("\(key)[\(nestedKey)]", value))
            }
        } else if let array = value as? [Any] {
            for value in array {
                components.append(contentsOf: queryComponents("\(key)[]", value))
            }
        } else {
            components.append((key, "\(value)"))
        }
        
        return components
    }
}

extension DefaultURLEncoder {
    
    enum Error: Swift.Error {
        
        // MARK: - Cases
        
        case unconvertibleString
    }
    
}
