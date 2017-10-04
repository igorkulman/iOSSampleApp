//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift

class CustomSourceViewModel {
    
    // MARK: - Properties
    
    let title = Variable<String?>(nil)
    let url = Variable<String?>(nil)
    let logoUrl = Variable<String?>(nil)
    let rssUrl = Variable<String?>(nil)
    
    let isValid: Observable<Bool>
    
    // MARK: - Fields
    
    private let notificationService: NotificationService
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
        
        isValid = Observable.combineLatest(title.asObservable(), url.asObservable(), rssUrl.asObservable()) {
            let isTitleValid = !($0 ?? "").isEmpty
            let isUrlValid = $1?.isValidURL == true
            let isRssUrlValid = $2?.isValidURL == true
            
            return isTitleValid && isUrlValid && isRssUrlValid
        }
    }
    
    // MARK: - Actions
    
    func submit() -> Bool {
        guard let title = title.value, let url = url.value, URL(string: url) != nil, let rss = rssUrl.value, URL(string: rss) != nil else {
            return false
        }
        
        notificationService.announceSourceAdded(source: RssSource(title: title, url: url, rss: rss, icon: logoUrl.value))
        return true
    }
}
