//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol RequestFactory {
    
    // MARK: - API
    
    func request<RequestType: NetworkRequest>(for object: RequestType) -> URLRequest
}
