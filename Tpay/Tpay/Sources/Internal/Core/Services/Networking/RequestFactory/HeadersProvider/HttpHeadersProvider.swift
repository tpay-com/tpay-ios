//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol HttpHeadersProvider: AnyObject {
    
    // MARK: - API
    
    func headers(for resource: NetworkResource) -> [HttpHeader]
}
