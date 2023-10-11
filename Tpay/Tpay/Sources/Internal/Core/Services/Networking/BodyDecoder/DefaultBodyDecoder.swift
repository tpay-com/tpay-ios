//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultBodyDecoder: BodyDecoder {
    
    // MARK: - Properties
    
    private let decoder: ObjectDecoder
    
    // MARK: - Initializers
    
    init(using decoder: ObjectDecoder) {
        self.decoder = decoder
    }
    
    // MARK: - API
    
    func decode<ObjectType: Decodable>(body: Data) throws -> ObjectType {
        guard body.isNotEmpty else { return try decoder.decode(ObjectType.self, from: "{}".data(using: .utf8).value(or: body)) }
        return try decoder.decode(ObjectType.self, from: body)
    }
    
}
