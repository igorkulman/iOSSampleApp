//
//  RxSwift+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var textColor: UIBindingObserver<Base, UIColor?> {
        return UIBindingObserver(UIElement: base) { label, textColor in
            label.textColor = textColor
        }
    }
}
