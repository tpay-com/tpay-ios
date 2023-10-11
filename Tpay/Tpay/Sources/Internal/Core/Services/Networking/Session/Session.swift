//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol Session {
    
    // MARK: - API
    
    func invoke(request: URLRequest, then: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}
