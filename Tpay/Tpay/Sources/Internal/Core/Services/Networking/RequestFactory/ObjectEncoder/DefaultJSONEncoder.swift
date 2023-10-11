//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultJSONEncoder: ObjectEncoder {
    
    // MARK: - Properties
    
    private let dateEncoder: DateEncoder
    private let encoder: JSONEncoder
    
    // MARK: - Initializers
    
    init(using encoder: JSONEncoder, dateEncoder: DateEncoder) {
        self.dateEncoder = dateEncoder
        self.encoder = encoder
        
        encoder.dateEncodingStrategy = .custom(dateEncoder.encode)
    }
    
    // MARK: - API
    
    func encode<ValueType: Encodable>(_ object: ValueType) throws -> Data {
        try encoder.encode(object)
    }
}
