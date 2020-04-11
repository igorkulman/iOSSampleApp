//
//  DashboardViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import os.log
import RxSwift
import UIKit

final class FeedViewModel {

    // MARK: - Properties

    /**
     Observable with error from the feed refresh
     */
    let onError: Observable<Error>

    /**
     Observable with actual data. Does not change when feed refresh errors out
     */
    let feed: Observable<[RssItem]>

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
            fail("Source not selected, nothing to show in feed")
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
            .startWith(()) // start loading immediatelly
            .flatMapLatest { _ in
                return loadFeed.materialize() // converting the feed to Observable<Event<[RssItem]>> contaitning both data and error so the observable does not complete on error
            }
            .share() // sharing the subscription so network calls are not duplicated
            .observeOn(MainScheduler.instance) // making sure the result is returned in the UI thread

        feed = response.elements()
        onError = response.errors()
        title = source.title

        // refreshing the feed on app activation
        NotificationCenter.default.rx.applicationWillEnterForeground().bind { [weak self] in
            self?.load.onNext(())
        }.disposed(by: disposeBag)
    }
}
