//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum NetworkingError: Error {
    
    // MARK: - Cases
    
    // Server-side
    case badRequest(BadRequest)
    case invalidResponse(InvalidResponse)
    case serverError(ServerError)
    case unknownStatusCode(statusCode: Int)
    case serviceUnavailable
    
    // Connection-side
    case noInternetConnection
    case requestTimeout
    case hostNotReachable
    case requestCancelled
}
