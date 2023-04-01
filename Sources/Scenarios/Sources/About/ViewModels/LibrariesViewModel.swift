//
//  LibrariesViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Foundation
import RxSwift

typealias Library = (String, String)

final class LibrariesViewModel {

    // MARK: - Properties

    let libraries: Observable<[Library]>

    init() {
        guard let path = Bundle.module.path(forResource: "Licenses", ofType: "plist"), let array = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            fail("Invalid bundle licenses file")
        }

        libraries = Observable.just(array.map {
            let title = $0["title"] as! String
            let license = $0["license"] as! String
            return (title, license)
        })
    }
}
