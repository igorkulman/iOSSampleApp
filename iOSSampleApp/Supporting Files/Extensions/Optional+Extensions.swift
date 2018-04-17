//
//  Optional+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 17/04/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

extension Optional {
    var isNone: Bool {
        return self == nil
    }

    var isSome: Bool {
        return self != nil
    }
}
