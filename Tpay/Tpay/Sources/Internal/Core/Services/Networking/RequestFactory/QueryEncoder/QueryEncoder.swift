//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol QueryEncoder: AnyObject {
    
    // MARK: - API
    
    func queryItems<ObjectType: Encodable>(from object: ObjectType) -> [URLQueryItem]?
}
