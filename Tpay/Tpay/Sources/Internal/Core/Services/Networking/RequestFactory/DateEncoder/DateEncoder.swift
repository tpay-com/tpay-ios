//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol DateEncoder: AnyObject {
    
    // MARK: - API
    
    func encode(date: Date, into encoder: Encoder) throws
}
