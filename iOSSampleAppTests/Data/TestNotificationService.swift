//
//  TestNotificationService.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
@testable import iOSSampleApp

class TestNotificationService: NotificationService {
    func announceSourceAdded(source _: RssSource) {
    }

    func sourceAdded() -> ControlEvent<RssSource> {
        return ControlEvent(events: Observable.empty())
    }
}
