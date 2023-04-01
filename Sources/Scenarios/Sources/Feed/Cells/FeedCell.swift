//
//  FeedCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Operators
import Reusable
import UIKit

final class FeedCell: UITableViewCell, Reusable {

    // MARK: - UI

    private lazy var titleLabel: UILabel = .init() &> {
        $0.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 17, weight: .semibold))
        $0.adjustsFontForContentSizeCategory = true
    }

    private lazy var descriptionLabel: UILabel = .init() &> {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 3
    }

    // MARK: - Properties

    var model: RssItem? {
        didSet {
            guard let model = model else {
                return
            }

            titleLabel.text = model.title
            descriptionLabel.text = model.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true

        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, descriptionLabel]) &> {
            $0.axis = .vertical
        }

        stackView.pin(to: self, guide: layoutMarginsGuide)
    }
}
