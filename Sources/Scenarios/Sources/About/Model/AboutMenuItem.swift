//
//  AboutMenuItem.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import Resources

enum AboutMenuItem: CaseIterable {
    case libraries
    case aboutAuthor
    case authorsBlog
}

extension AboutMenuItem {
    var title: String {
        switch self {
        case .libraries:
            return L10n.libraries
        case .aboutAuthor:
            return L10n.author
        case .authorsBlog:
            return L10n.blog
        }
    }
}
