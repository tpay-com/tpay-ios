//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol AuthenticationService: AnyObject {
    
    // MARK: - API
    
    func authenticate(then: @escaping Completion)
}
