//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Logger {
    
    static func request(_ urlRequest: URLRequest) {
        var logLevel: String { "\(Logger.currentDate) \(LogLevel.request.value())" + .space }
        var log: String = .empty
        
        log += logLevel + "Application will send request" + .newLine
        log += logLevel + "\tTo: \(urlRequest.description)" + .newLine
        log += logLevel + "\tHTTP Method: \(urlRequest.httpMethod.value(or: .empty))" + .newLine
        log += logLevel + "\tHTTP Headers: \(urlRequest.description)" + .newLine
        for header in urlRequest.allHTTPHeaderFields.value(or: [:]) {
            log += logLevel + "\t\t\(header.key): \(header.value)" + .newLine
        }
        if let body = urlRequest.httpBody.flatMap({ String(bytes: $0, encoding: .utf8) }) {
            log += logLevel + "\tBody:" + .newLine
            log += logLevel + "\t\t\(body)" + .newLine
        }
        
        if Logger.isLoggingEnabled {
            print(log)
        }
        if Logger.isWritingToFileEnabled {
            Logger.writeToFile(text: log)
        }
    }
    
    static func response(_  data: Data?, _ response: URLResponse?, _ error: Error?) {
        var logLevel: String { "\(Logger.currentDate) \(LogLevel.response.value())" + .space }
        var log: String = .empty
        
        log += logLevel + "Application did receive response" + .newLine
        if let response = response {
            log += logLevel + "\tFrom: \((response.url?.absoluteString).value(or: "unknown url"))" + .newLine
            if let httpResponse = response as? HTTPURLResponse {
                log += logLevel + "\t\tStatus code: \(httpResponse.statusCode)" + .newLine
                log += logLevel + "\t\tHTTP headers:" + .newLine
                for header in httpResponse.allHeaderFields {
                    log += logLevel + "\t\t\t\(header.key.description): \(header.value)" + .newLine
                }
            }
        }
        if let data = data {
            log += logLevel + "\tData:" + .newLine
            log += logLevel + "\t\t" + String(bytes: data, encoding: .utf8).value(or: "[Error] response data is not convertible to utf8 string") + .newLine
        }
        if let error = error {
            log += logLevel + "\tError:" + .newLine
            log += logLevel + "\t\t\(error.localizedDescription)" + .newLine
        }
        
        if Logger.isLoggingEnabled {
            print(log)
        }
        if Logger.isWritingToFileEnabled {
            Logger.writeToFile(text: log)
        }
    }
    
}
