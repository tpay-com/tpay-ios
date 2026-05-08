//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

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

    // Configuration-side (TPS-55) — replaces former preconditionFailure crashes
    case notConfigured
    case invalidURL
}

// LocalizedError conformance is in NetworkingError+Localized.swift (extended there for the new cases).
