//
//  LeaksAnalyzer.swift
//  UnitTestLeaks
//
//  Created by Leandro Perez on 03/02/2018.
//  Copyright © 2018 Leandro Perez. All rights reserved.
//

import Foundation

class LeaksAnalyzer {
    weak var leakedObject: AnyObject?

    func analize(_ leakingObject: AnyObject) {
        self.leakedObject = leakingObject
    }
}
