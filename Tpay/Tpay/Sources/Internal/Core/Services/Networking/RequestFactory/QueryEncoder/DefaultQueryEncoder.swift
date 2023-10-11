//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultQueryEncoder: QueryEncoder {
    
    // MARK: - Properties
    
    private let jsonEncoder: ObjectEncoder
    private let jsonSerializer: JSONSerializer
    
    // MARK: - Initializers
    
    init(using encoder: ObjectEncoder, _ serializer: JSONSerializer) {
        jsonEncoder = encoder
        jsonSerializer = serializer
    }
    
    // MARK: - API
    
    func queryItems<ObjectType: Encodable>(from object: ObjectType) -> [URLQueryItem]? {
        do {
            let data = try jsonEncoder.encode(object)
            let dictionary = try jsonSerializer.dictionary(from: data)

            guard dictionary.isEmpty == false else { return nil }

            return dictionary.map { keyValue in URLQueryItem(name: keyValue.key, value: map(keyValue.value)) }
        } catch {
            return nil
        }
    }
    
    // MARK: - Private
    
    private func map(_ value: Any) -> String {
        switch value {
        case let string as String: return string
        case let bool as Bool: return bool.description
        case let int as Int: return int.description
        default: fatalError("Unimplemented mapping for value: \(value)")
        }
    }
    
}
