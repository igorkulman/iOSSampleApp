//
//  Coordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject

protocol Coordinator: class {
    var container: Container { get }
    func start()
}
