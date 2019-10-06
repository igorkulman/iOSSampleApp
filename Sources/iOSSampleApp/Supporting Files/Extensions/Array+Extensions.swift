//
//  Array+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 10/05/2019.
//  Copyright © 2019 Igor Kulman. All rights reserved.
//

import Foundation

extension Array {
    func inserting(_ newElement: Element, at index: Int) -> [Element] {
        var arr = self
        arr.insert(newElement, at: index)
        return arr
    }
}
