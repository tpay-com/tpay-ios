//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol BodyDecoder {
    
    // MARK: - API
    
    func decode<ObjectType: Decodable>(body: Data) throws -> ObjectType
}
