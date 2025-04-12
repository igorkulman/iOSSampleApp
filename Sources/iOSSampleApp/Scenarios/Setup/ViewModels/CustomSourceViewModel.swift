//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class CustomSourceViewModel {

    // MARK: - Properties

    let title = BehaviorRelay<String?>(value: nil)
    let url = BehaviorRelay<String?>(value: nil)
    let logoUrl = BehaviorRelay<String?>(value: nil)
    let rssUrl = BehaviorRelay<String?>(value: nil)

    let isValid: Driver<Bool>
    let source: Driver<RssSource?>

    init() {
        source = Observable.combineLatest(title.asObservable(), url.asObservable(), rssUrl.asObservable(), logoUrl.asObservable()) { title, url, rssUrl, logoUrl in
            guard let title = title, !title.isEmpty, let url = url, url.isValidURL, let urlValue = URL(string: url), let rssUrl = rssUrl, rssUrl.isValidURL, let rssUrlValue = URL(string: rssUrl) else {
                return nil
            }

            return RssSource(title: title, url: urlValue, rss: rssUrlValue, icon: logoUrl.flatMap({ URL(string: $0) }))
        }.asDriver(onErrorJustReturn: nil)

        isValid = source.map({ $0.isSome }).asDriver(onErrorJustReturn: false)
    }
}
