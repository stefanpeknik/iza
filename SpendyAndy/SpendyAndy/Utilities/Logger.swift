//
//  Logger.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

enum Logger {
    enum LogLevel: Int {
        case debug = 0
        case info = 2
        case warning = 3
        case error = 4
        
        fileprivate var prefix: String {
            switch self {
            case .debug:   return "DEBUG 🔧"
            case .info:    return "INFO ℹ️"
            case .warning: return "WARN ⚠️"
            case .error:   return "ALERT ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
   
    static func debug(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .debug, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    static func warning(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    static func error(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }

    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context) {
        // log current time as well
        let logComponents = [DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium), "[\(level.prefix)]", str]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " ➜ \(context.description)"
        }
        
        let currentLogLevel: LogLevel = .debug // Set your desired log level here
        
        if level.rawValue >= currentLogLevel.rawValue {
#if DEBUG
            print(fullString)
#endif
        }
    }
}
