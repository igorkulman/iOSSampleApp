//
//  UIViewController+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 16/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import UIKit

protocol ToastCapable: AnyObject {
    func showErrorToast(message: String)
}

extension ToastCapable where Self: UIViewController {
    func showErrorToast(message: String) {
        let banner = StatusBarNotificationBanner(title: message, style: .danger)
        banner.show()
    }
}
