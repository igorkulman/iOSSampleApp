//
//  OSLog+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 29/03/2019.
//  Copyright © 2019 Igor Kulman. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let data = OSLog(subsystem: subsystem, category: "data")
    static let lifeCycle = OSLog(subsystem: subsystem, category: "lifeCycle")
}
