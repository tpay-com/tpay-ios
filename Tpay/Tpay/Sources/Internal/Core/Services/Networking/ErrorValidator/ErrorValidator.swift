//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ErrorValidator {
    
    // MARK: - API
    
    func validate(error: Error?) throws
}
