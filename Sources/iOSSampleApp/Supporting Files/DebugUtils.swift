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

func failDebug(_ logMessage: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let formattedMessage = formatLogMessage(logMessage, file: file, function: function, line: line)
    OSLog.log(formattedMessage, log: OSLog.conditions, type: .error)
    assertionFailure(formattedMessage, file: file, line: line)
}

func fail(_ logMessage: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Never {
    let formattedMessage = formatLogMessage(logMessage, file: file, function: function, line: line)
    OSLog.log(formattedMessage, log: OSLog.conditions, type: .error)
    fatalError(logMessage, file: file, line: line)
}

func notImplemented(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Never {
    fail("Method not implemented.", file: file, function: function, line: line)
}

func formatLogMessage(_ logString: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> String {
    let filename = (file.withUTF8Buffer {
        String(decoding: $0, as: UTF8.self)
    } as NSString).lastPathComponent
    return "[\(filename):\(line) \(function)]: \(logString)"
}

func assertDebug(_ condition: @autoclosure () -> Bool, _ logMessage: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if DEBUG
    if !condition() {
        failDebug(logMessage, file: file, function: function, line: line)
    }
    #endif
}
