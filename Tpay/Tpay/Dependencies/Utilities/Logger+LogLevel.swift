//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Logger {
    
    private static var logProjectName: String {
        guard projectName.isNotEmpty else { return .empty }
        return "[\(projectName)]"
    }
    
    enum LogLevel: String {
        case error
        case info
        case debug
        case request
        case response
        
        func value() -> String {
            switch self {
            case .error: return logProjectName + "[❗️]"
            case .info: return logProjectName + "[💬]"
            case .debug: return logProjectName + "[🟠]"
            case .request: return logProjectName + "[Request]"
            case .response: return logProjectName + "[Response]"
            }
        }
    }
    
}
