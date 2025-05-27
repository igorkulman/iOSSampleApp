//
//  LibraryCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

final class LibraryCell: UITableViewCell, Reusable {

    // MARK: - Properties

    var model: Library?

    // MARK: - Configuration

    override func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = UIListContentConfiguration.subtitleCell() &> {
            $0.text = model?.title
            $0.secondaryText = model?.license
        }
    }
}
