//
//  FeedCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import Reusable

class FeedCell: UITableViewCell, NibReusable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var model: RssItem? {
        didSet {
            if let model = model {
                titleLabel.text = model.title
                descriptionLabel.text = model.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // no pre-defined text style matches, so creating the font in code is needed
        titleLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 17, weight: .semibold))
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
