//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ResponseValidator {
    
    // MARK: - API
    
    func validate(response: URLResponse?, with data: Data?) throws
}
