//
//  DashboardViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import Foundation
import RxSwift
import UIKit

class FeedViewModel {

    // MARK: - Properties

    let feed: Observable<[RssItem]>
    let load = PublishSubject<Void>() // signal that starts feed loading
    let title: String

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    init(dataService: DataService, settingsService: SettingsService) {
        guard let source = settingsService.selectedSource else {
            Log.error?.message("Source not selected, nothing to show in feed")
            fatalError("Source not selected, nothing to show in feed")
        }

        let loadFeed: Observable<[RssItem]> = Observable.create { observer in
            dataService.getFeed(source: source) { result in
                switch result {
                case let .failure(error):
                    observer.onError(error)
                case let .success(items):
                    observer.onNext(items)
                    observer.onCompleted()
                }
            }

            return Disposables.create {
            }
        }
        feed = load.startWith(()).flatMapLatest { _ in return loadFeed }.share()
        title = source.title

        NotificationCenter.default.rx.applicationWillEnterForeground().subscribe(onNext: { [weak self] in
            self?.load.onNext(())
        }).disposed(by: disposeBag)
    }
}
