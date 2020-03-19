//
//  URL+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 19/03/2020.
//  Copyright © 2020 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

extension URL: ExpressibleByStringLiteral {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = URL(string: value)!
    }

    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
