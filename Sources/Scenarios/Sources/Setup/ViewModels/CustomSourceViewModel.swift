//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Foundation
import RxCocoa
import RxSwift

final class CustomSourceViewModel {

    // MARK: - Properties

    let title = BehaviorRelay<String?>(value: nil)
    let url = BehaviorRelay<String?>(value: nil)
    let logoUrl = BehaviorRelay<String?>(value: nil)
    let rssUrl = BehaviorRelay<String?>(value: nil)

    let isValid: Observable<Bool>
    let source: Observable<RssSource?>

    init() {
        source = Observable.combineLatest(title.asObservable(), url.asObservable(), rssUrl.asObservable(), logoUrl.asObservable()) { title, url, rssUrl, logoUrl -> RssSource? in
            guard let title = title, !title.isEmpty, let url = url, url.isValidURL, let rssUrl = rssUrl, rssUrl.isValidURL else {
                return nil
            }

            return RssSource(title: title, url: url, rss: rssUrl, icon: logoUrl)
        }

        isValid = source.map({ $0.isSome })
    }
}
