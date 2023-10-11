//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension NetworkingError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return Strings.noInternetConnection
        default:
            return Strings.somethingWentWrong
        }
    }
}
