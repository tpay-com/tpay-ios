//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultResponseValidator: ResponseValidator {
    
    // MARK: - Properties
    
    private let decoder: ObjectDecoder
    
    // MARK: - Initializers

    init(using decoder: ObjectDecoder) {
        self.decoder = decoder
    }
    
    // MARK: - API
    
    func validate(response: URLResponse?, with data: Data?) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse(.undecodableResponseBody)
        }
        guard let statusCode = HttpStatusCode(rawValue: response.statusCode) else {
            throw NetworkingError.unknownStatusCode(statusCode: response.statusCode)
        }
        
        if statusCode == .badRequest {
            throw NetworkingError.badRequest(try decode(data: data))
        }
        if statusCode == .serviceUnavailable {
            throw NetworkingError.serviceUnavailable
        }

        guard (200 ... 299).contains(statusCode.rawValue) else {
            let errors = try decode(data: data) as ServiceErrors
            throw NetworkingError.serverError(ServerError(httpStatusCode: statusCode, errors: errors))
        }
    }
    
    private func decode(data: Data?) throws -> BadRequest {
        guard let data = data else {
            throw NetworkingError.invalidResponse(.lackDataInResponseBody)
        }
        
        do {
            return try decoder.decode(BadRequest.self, from: data)
        } catch {
            let error = String(bytes: data, encoding: .utf8).value(or: "n/a")
            Logger.error("[RESPONSE] Unable to decode response data: \(error)")
            throw NetworkingError.invalidResponse(.undecodableResponseBody)
        }
    }
    
    private func decode(data: Data?) throws -> ServiceErrors {
        guard let data = data else {
            throw NetworkingError.invalidResponse(.lackDataInResponseBody)
        }
        
        do {
            return try decoder.decode(ServiceErrors.self, from: data)
        } catch {
            let error = String(bytes: data, encoding: .utf8).value(or: "n/a")
            Logger.error("[RESPONSE] Unable to decode response data: \(error)")
            throw NetworkingError.invalidResponse(.undecodableResponseBody)
        }
    }
}
