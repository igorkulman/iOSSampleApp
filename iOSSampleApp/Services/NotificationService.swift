//
//  NotificationService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

class NotificationService {
    func announceSourceAdded(source: RssSource) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sourceAdded"), object: source)
    }
    
    func sourceAdded() -> ControlEvent<RssSource> {
        let source = NotificationCenter.default.rx.notification(Notification.Name(rawValue: "sourceAdded")).map({ $0.object as! RssSource })
        return ControlEvent(events: source)
    }
}
