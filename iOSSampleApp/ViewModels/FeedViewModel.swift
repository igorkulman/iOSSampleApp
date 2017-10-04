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

class FeedViewModel {
    
    // MARK: - Properties
    
    let feed: Observable<[RssItem]>
    
    init(dataService: DataService, settingsService: SettingsService) {
        
        if let source = settingsService.selectedSource {
            feed = Observable.create { observer in
                dataService.getFeed(source: source) { items in
                    observer.onNext(items)
                    observer.onCompleted()
                }
                
                return Disposables.create {
                }
            }
        } else {
            Log.error?.message("Source not selected, nothing to show in feed")
            feed = Observable.just([])
        }
    }
}
