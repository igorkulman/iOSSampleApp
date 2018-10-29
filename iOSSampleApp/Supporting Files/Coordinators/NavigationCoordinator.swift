//
//  NavigationCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import UIKit

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
    var container: Container { get }
}
