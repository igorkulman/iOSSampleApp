//
//  UIScrollView+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func setBottomInset(height: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
    }
}
