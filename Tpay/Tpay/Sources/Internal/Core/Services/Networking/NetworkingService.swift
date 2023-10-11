//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol NetworkingService: AnyObject {
    
    // MARK: - API
    
    func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType
}
