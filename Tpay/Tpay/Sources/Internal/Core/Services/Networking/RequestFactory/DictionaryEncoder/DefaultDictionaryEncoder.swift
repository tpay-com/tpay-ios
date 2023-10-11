//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultDictionaryEncoder: DictionaryEncoder {
    
    // MARK: - Properties
    
    private let jsonEncoder: ObjectEncoder
    private let jsonSerializer: JSONSerializer
    
    // MARK: - Initializers
    
    init(using encoder: ObjectEncoder, _ serializer: JSONSerializer) {
        jsonEncoder = encoder
        jsonSerializer = serializer
    }
    
    // MARK: - API
    
    func encode<ObjectType: Encodable>(_ value: ObjectType) throws -> [String: Any] {
        let data = try jsonEncoder.encode(value)
        return try jsonSerializer.dictionary(from: data)
    }
}
