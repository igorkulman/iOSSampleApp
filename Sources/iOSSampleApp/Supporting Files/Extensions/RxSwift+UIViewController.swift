//
//  RxSwift+UIViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/12/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var toolbarItems: Binder<[UIBarButtonItem]> {
        return Binder(base) { vc, items in
            vc.toolbarItems = items
        }
    }
}
