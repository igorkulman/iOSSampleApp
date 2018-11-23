//
//  RxSwift+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITextField {
    var textColor: Binder<UIColor?> {
        return Binder(base) { label, textColor in
            label.textColor = textColor
        }
    }
}

extension Reactive where Base: NotificationCenter {
    func keyboardHeightChanged() -> ControlEvent<CGFloat> {
        let showSource = notification(UIResponder.keyboardDidShowNotification).map({ (value: Notification) -> CGFloat in
            let userInfo: NSDictionary = value.userInfo! as NSDictionary
            let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
            return keyboardSize.height
        })
        let hideSource = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map({ _ in CGFloat(0) })

        let source = Observable.of(showSource, hideSource).merge()
        return ControlEvent(events: source)
    }

    func applicationWillEnterForeground() -> ControlEvent<Void> {
        let source = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map({ _ in Void() })
        return ControlEvent(events: source)
    }
}

func ignoreNil<A>(x: A?) -> Observable<A> {
    return x.map { Observable.just($0) } ?? Observable.empty()
}
