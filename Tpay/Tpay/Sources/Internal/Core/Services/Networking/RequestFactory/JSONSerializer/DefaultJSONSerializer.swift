//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultJSONSerializer: JSONSerializer {
    
    // MARK: - API

    func dictionary(from data: Data) throws -> [String: Any] {
        (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]) ?? [:]
    }
}
