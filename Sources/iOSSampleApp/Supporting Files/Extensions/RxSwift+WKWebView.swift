//
//  RxSwift+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/12/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WebKit

extension Reactive where Base: WKWebView {
    var title: Observable<String?> {
        return observeWeakly(String.self, "title")
    }

    var loading: Observable<Bool> {
        return observeWeakly(Bool.self, "loading").map { $0 ?? false }
    }

    var estimatedProgress: Observable<Double> {
        return observeWeakly(Double.self, "estimatedProgress").map { $0 ?? 0.0 }
    }

    var url: Observable<URL?> {
        return observeWeakly(URL.self, "URL")
    }

    var canGoBack: Observable<Bool> {
        return observeWeakly(Bool.self, "canGoBack").map { $0 ?? false }
    }

    var canGoForward: Observable<Bool> {
        return observeWeakly(Bool.self, "canGoForward").map { $0 ?? false }
    }
}
