//
//  LibrariesViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift

typealias Library = (String, String)

class LibrariesViewModel {

    // MARK: - Properties

    let libraries: Observable<[Library]>

    init() {
        if let path = Bundle.main.path(forResource: "Licenses", ofType: "plist"), let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
            libraries = Observable.just(array.map({ dict in

                let title = dict["title"] as! String
                let license = dict["license"] as! String

                return (title, license)
            }))
        } else {
            libraries = Observable.just([])
        }
    }
}
