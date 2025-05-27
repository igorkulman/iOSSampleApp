//
//  RssSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class RssSourceViewModel {
    let source: RssSource
    let isSelected = BehaviorRelay<Bool>(value: false)
    let icon: Driver<UIImage?>

    private static let cache = NSCache<NSURL, UIImage>()

    init(source: RssSource) {
        self.source = source

        guard let iconUrl = source.icon else {
            icon = Driver.just(nil)
            return
        }

        icon = Observable<UIImage?>.create { observer in
            if let cached = RssSourceViewModel.cache.object(forKey: iconUrl as NSURL) {
                observer.onNext(cached)
                observer.onCompleted()
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: iconUrl) { data, _, error in
                guard let data = data,
                      let image = UIImage(data: data),
                      error == nil else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }

                RssSourceViewModel.cache.setObject(image, forKey: iconUrl as NSURL)
                observer.onNext(image)
                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
        .asDriver(onErrorJustReturn: nil)
    }
}
