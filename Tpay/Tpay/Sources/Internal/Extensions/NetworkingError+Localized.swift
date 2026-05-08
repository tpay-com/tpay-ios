//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension NetworkingError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return Strings.noInternetConnection
        // TPS-55: developer-facing diagnostic messages for the new configuration errors
        // (replaces former preconditionFailure crashes). Not localized via Strings catalog
        // because these are integrator-facing, not end-user-facing.
        case .notConfigured:
            return "Tpay SDK is not configured. Call configure(merchant:) before performing payment requests."
        case .invalidURL:
            return "Tpay SDK could not build a valid URL for the request — check the merchant configuration host/scheme."
        default:
            return Strings.somethingWentWrong
        }
    }
}
