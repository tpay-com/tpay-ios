//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension NetworkingError {

    init?(with error: Error) {
        switch error._code {
        case NSURLErrorTimedOut:
            self = .requestTimeout
        case NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost:
            self = .hostNotReachable
        case NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed:
            self = .noInternetConnection
        case NSURLErrorCancelled:
            self = .requestCancelled
        default:
            return nil
        }
    }
}
