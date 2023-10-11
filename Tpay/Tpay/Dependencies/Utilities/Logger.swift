//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

enum Logger {

    // MARK: - Properties

    /// If you want access to the file in iOS "Files" application you should add to Info.plist keys:
    /// - UIFileSharingEnabled and set value as true
    /// - LSSupportsOpeningDocumentsInPlace and set value as true
    static var isWritingToFileEnabled: Bool = false
    
    static var isLoggingEnabled: Bool = true
    static var projectName: String = .empty

    static var currentDate: String {
        dateFormatter.string(from: Date())
    }
    
    fileprivate static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: - Methods
    
    static func separator() {
        let log: String = .newLine + "===================================================" + .newLine
        if isLoggingEnabled {
            print(log)
        }
        if isWritingToFileEnabled {
            writeToFile(text: log)
        }
    }
    
    static func error(_ object: Any, file: String = #file) {
        let log = "\(currentDate) \(LogLevel.error.value()) \(object) in \(file)"
        if isLoggingEnabled {
            print(log)
        }
        if isWritingToFileEnabled {
            writeToFile(text: log + .newLine)
        }
    }

    static func info(_ object: Any) {
        let log = "\(currentDate) \(LogLevel.info.value()) \(object)"
        if isLoggingEnabled {
            print(log)
        }
        if isWritingToFileEnabled {
            writeToFile(text: log + .newLine)
        }
    }
    
    static func debug(_ object: Any) {
        let log = "\(currentDate) \(LogLevel.debug.value()) \(object)"
        if isLoggingEnabled {
            print(log)
        }
        if isWritingToFileEnabled {
            writeToFile(text: log + .newLine)
        }
    }
    
    static func writeToFile(text: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
            let logFile = dir.appendingPathComponent(projectName + "Logs.txt")
            guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }

            if FileManager.default.fileExists(atPath: logFile.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFile, options: .atomic)
            }
        }
    }
    
}
