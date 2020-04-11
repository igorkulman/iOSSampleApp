//
//  DebugUtils.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 11/04/2020.
//  Copyright © 2020 Igor Kulman. All rights reserved.
//
// swiftlint:disable unavailable_function

import Foundation
import os.log

func failDebug(_ logMessage: String, file: String = #file, function: String = #function, line: Int = #line) {
    let formattedMessage = formatLogMessage(logMessage, file: file, function: function, line: line)
    OSLog.log(formattedMessage, log: OSLog.conditions, type: .error)
    assertionFailure(formattedMessage)
}

func fail(_ logMessage: String, file: String = #file, function: String = #function, line: Int = #line) -> Never {
    let formattedMessage = formatLogMessage(logMessage, file: file, function: function, line: line)
    OSLog.log(formattedMessage, log: OSLog.conditions, type: .error)
    fatalError(formattedMessage)
}

func notImplemented(file: String = #file, function: String = #function, line: Int = #line) -> Never {
    fail("Method not implemented.", file: file, function: function, line: line)
}

func formatLogMessage(_ logString: String, file: String = #file, function: String = #function, line: Int = #line) -> String {
    let filename = (file as NSString).lastPathComponent
    return "[\(filename):\(line) \(function)]: \(logString)"
}

func assertDebug(_ condition: @autoclosure () -> Bool, _ logMessage: String, file: String = #file, function: String = #function, line: Int = #line) {
    if !condition() {
        failDebug(logMessage)
    }
}
