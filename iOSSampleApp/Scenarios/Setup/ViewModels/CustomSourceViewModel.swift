//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger

class CustomSourceViewModel {

    // MARK: - Properties

    let title = Variable<String?>(nil)
    let url = Variable<String?>(nil)
    let logoUrl = Variable<String?>(nil)
    let rssUrl = Variable<String?>(nil)

    let isValid: Observable<Bool>

    init() {
        isValid = Observable.combineLatest(title.asObservable(), url.asObservable(), rssUrl.asObservable()) {
            let isTitleValid = !($0 ?? "").isEmpty
            let isUrlValid = $1?.isValidURL == true
            let isRssUrlValid = $2?.isValidURL == true

            return isTitleValid && isUrlValid && isRssUrlValid
        }
    }

    // MARK: - Actions

    func getCreatedSource() -> RssSource {
        guard let title = title.value, let url = url.value, URL(string: url) != nil, let rss = rssUrl.value, URL(string: rss) != nil else {
            Log.error?.message("Cannot process invalid form, validation is broken")
            fatalError("Cannot process invalid form, validation is broken")
        }

        return RssSource(title: title, url: url, rss: rss, icon: logoUrl.value)
    }
}
