//
//  DashboardViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger
import UIKit

class FeedViewModel {
    
    // MARK: - Properties
    
    let feed: Observable<[RssItem]>
    let load = PublishSubject<Void>()
    
    init(dataService: DataService, settingsService: SettingsService) {
        
        if let source = settingsService.selectedSource {
            let loadFeed: Observable<[RssItem]> = Observable.create { observer in
                dataService.getFeed(source: source) { items in
                    observer.onNext(items)
                    observer.onCompleted()
                }
                
                return Disposables.create {
                }
            }
            feed = load.startWith(()).flatMapLatest { _ in return loadFeed }.share()
        } else {
            Log.error?.message("Source not selected, nothing to show in feed")
            feed = Observable.just([])
        }
    }
}
