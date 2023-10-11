//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ObjectEncoder {
    
    // MARK: - API
    
    func encode<ValueType: Encodable>(_ object: ValueType) throws -> Data
}
