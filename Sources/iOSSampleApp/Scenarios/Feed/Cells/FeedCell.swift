//
//  FeedCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

final class FeedCell: UITableViewCell, Reusable {

    // MARK: - Properties

    var model: RssItem?

    // MARK: - Configuration

    override func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = UIListContentConfiguration.subtitleCell() &> {
            $0.text = model?.title
            $0.secondaryText = model?.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

            $0.textProperties.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 17, weight: .semibold))
            $0.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            $0.secondaryTextProperties.numberOfLines = 3
        }
    }
}
