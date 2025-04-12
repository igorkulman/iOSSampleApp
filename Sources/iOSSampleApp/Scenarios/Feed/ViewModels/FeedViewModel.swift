//
//  DashboardViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class FeedViewModel {

    // MARK: - Properties

    /**
     Driver with error from the feed refresh
     */
    let onError: Driver<Error>

    /**
     Driver with actual data. Does not change when feed refresh errors out
     */
    let feed: Driver<[RssItem]>

    /*
     Signal that starts feed loading when called from the VC
     */
    let load = PublishSubject<Void>()

    /**
     Feed title
     */
    let title: String

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    init(dataService: DataService, settingsService: SettingsService) {
        guard let source = settingsService.selectedSource else {
            fatalError("Source not selected, nothing to show in feed")
        }

        // converting callback based data service call to an observable
        // this observable can error out
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
                // empty because the data service does not support cancelling requests
            }
        }

        let response = load
            .startWith(()) // start loading immediately
            .flatMapLatest { _ in
                return loadFeed.materialize() // converting the feed to Observable<Event<[RssItem]>> containing both data and error so the observable does not complete on error
            }
            .share()

        feed = response.elements()
            .asDriver(onErrorJustReturn: [])

        onError = response.errors()
            .asDriver(onErrorJustReturn: RssError.emptyResponse)

        title = source.title

        // refreshing the feed on app activation
        NotificationCenter.default.rx.applicationWillEnterForeground().withUnretained(self).bind { owner, _ in
            owner.load.onNext(())
        }.disposed(by: disposeBag)
    }
}
