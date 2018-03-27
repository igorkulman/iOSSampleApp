//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import Foundation
import RxSwift

class CustomSourceViewModel {

    // MARK: - Properties

    let title = Variable<String?>(nil)
    let url = Variable<String?>(nil)
    let logoUrl = Variable<String?>(nil)
    let rssUrl = Variable<String?>(nil)

    let isValid: Observable<Bool>
    let source: Observable<RssSource?>

    init() {
        source = Observable.combineLatest(title.asObservable(), url.asObservable(), rssUrl.asObservable(), logoUrl.asObservable()) { title, url, rssUrl, logoUrl in
            guard let title = title, !title.isEmpty, let url = url, !url.isEmpty, let rssUrl = rssUrl, !rssUrl.isEmpty else {
                return nil
            }

            return RssSource(title: title, url: url, rss: rssUrl, icon: logoUrl)
        }

        isValid = source.map({ $0 != nil })
    }
}
