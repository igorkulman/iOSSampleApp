//
//  AboutMenuItem.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation

enum AboutMenuItem: CaseIterable {
    case libraries
    case aboutAuthor
    case authorsBlog
}

extension AboutMenuItem {
    var title: String {
        switch self {
        case .libraries:
            return String(localized: .libraries)
        case .aboutAuthor:
            return String(localized: .author)
        case .authorsBlog:
            return String(localized: .blog)
        }
    }
}
