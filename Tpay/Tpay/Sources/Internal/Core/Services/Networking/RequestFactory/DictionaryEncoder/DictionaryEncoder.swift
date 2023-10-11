//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol DictionaryEncoder: AnyObject {

    // MARK: - API
    
    func encode<ObjectType: Encodable>(_ value: ObjectType) throws -> [String: Any]
}
