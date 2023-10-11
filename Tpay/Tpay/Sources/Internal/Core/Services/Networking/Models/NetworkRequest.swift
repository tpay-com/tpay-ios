//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol NetworkRequest: Encodable {
        
    associatedtype ResponseType: Decodable
    
    // MARK: - Properties
    
    var resource: NetworkResource { get }
}
