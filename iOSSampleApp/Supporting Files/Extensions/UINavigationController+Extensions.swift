//
//  UINavigationController+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func adjust() {
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.view.backgroundColor = UIColor.white
        }
    }
}
