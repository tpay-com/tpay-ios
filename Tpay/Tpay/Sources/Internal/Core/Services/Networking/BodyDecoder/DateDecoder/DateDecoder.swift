//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol DateDecoder: AnyObject {
    
    // MARK: - API
    
    func date(from decoder: Decoder) throws -> Date
}
