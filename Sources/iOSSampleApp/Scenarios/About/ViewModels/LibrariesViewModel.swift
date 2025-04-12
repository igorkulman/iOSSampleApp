//
//  LibrariesViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class LibrariesViewModel {

    // MARK: - Properties

    let libraries: Driver<[Library]>

    init() {
        guard let path = Bundle.main.path(forResource: "Licenses", ofType: "plist"), let array = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            fatalError("Invalid bundle linceses file")
        }

        libraries = Observable.just(array.map {
            let title = $0["title"] as! String
            let license = $0["license"] as! String
            return Library(title: title, license: license)
        }).asDriver(onErrorJustReturn: [])
    }
}
