//
//  Log.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 23/07/2020.
//  Copyright © 2020 Igor Kulman. All rights reserved.
//

import Foundation
import os.log

final class Log {
    static func error(_ message: String) {
        os_log("%@", log: .default, type: .error, message)
    }

    static func debug(_ message: String) {
        os_log("%@", log: .default, type: .debug, message)
    }
}
