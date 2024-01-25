//
//  Log.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 23/07/2020.
//  Copyright © 2020 Igor Kulman. All rights reserved.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let data = Logger(subsystem: subsystem, category: "data")
    static let appFlow = Logger(subsystem: subsystem, category: "appFlow")
}
