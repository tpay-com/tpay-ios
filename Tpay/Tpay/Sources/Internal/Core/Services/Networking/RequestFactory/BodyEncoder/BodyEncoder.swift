//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol BodyEncoder: AnyObject {
    
    // MARK: - API
    
    func body<ObjectType: Encodable>(from object: ObjectType, for resource: NetworkResource) -> Data?
}
