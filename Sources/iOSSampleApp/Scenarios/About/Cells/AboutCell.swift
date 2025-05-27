//
//  AboutCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

final class AboutCell: UITableViewCell, Reusable {

    // MARK: - Properties

    var model: AboutMenuItem?

    // MARK: - Configuration

    override func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = defaultContentConfiguration() &> {
            $0.text = model?.title
        }
    }
}
