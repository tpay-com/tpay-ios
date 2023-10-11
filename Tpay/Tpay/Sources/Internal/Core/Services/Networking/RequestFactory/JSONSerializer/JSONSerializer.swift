//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol JSONSerializer: AnyObject {
    
    // MARK: - API
    
    func dictionary(from data: Data) throws -> [String: Any]
}
