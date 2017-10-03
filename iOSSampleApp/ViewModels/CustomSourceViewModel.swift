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
    let rssUrl =  Variable<String?>(nil)
    
    let isValid: Observable<Bool>
    let rssUrlIsValid: Observable<Bool>
    let logoUrlIsValid: Observable<Bool>
    let urlIsValid: Observable<Bool>
    
    init() {
        rssUrlIsValid = rssUrl.asObservable().map({ !($0 ?? "").isEmpty && URL(string: $0!) != nil })
        logoUrlIsValid = logoUrl.asObservable().map({ !($0 ?? "").isEmpty && URL(string: $0!) != nil })
        urlIsValid = url.asObservable().map({ !($0 ?? "").isEmpty && URL(string: $0!) != nil })
        
        isValid = Observable.combineLatest(title.asObservable(), urlIsValid, rssUrlIsValid) {
            let isTitleValid = !($0 ?? "").isEmpty
            
            return isTitleValid && $1 && $2
        }
    }
}
