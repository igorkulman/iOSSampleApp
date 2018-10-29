//
//  UIViewController+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 16/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CRToast
import Foundation
import UIKit

protocol ToastCapable: AnyObject {
    func showErrorToast(message: String)
}

extension ToastCapable where Self: UIViewController {
    func showErrorToast(message: String) {
        CRToastManager.setDefaultOptions([kCRToastFontKey: UIFont.systemFont(ofSize: 14)])
        CRToastManager.dismissAllNotifications(false)

        let options: [NSObject: AnyObject] = [
            kCRToastTextKey as NSObject: message as AnyObject,
            kCRToastBackgroundColorKey as NSObject: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1),
            kCRToastTextColorKey as NSObject: UIColor.white,
            kCRToastNotificationTypeKey as NSObject: NSNumber(value: CRToastType.statusBar.rawValue),
            kCRToastNotificationPresentationTypeKey as NSObject: NSNumber(value: CRToastPresentationType.cover.rawValue)
        ]

        CRToastManager.showNotification(options: options, completionBlock: nil)
    }
}
