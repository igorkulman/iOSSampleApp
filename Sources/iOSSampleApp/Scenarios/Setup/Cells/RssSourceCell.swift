//
//  RssSourceCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxSwift
import UIKit

final class RssSourceCell: UITableViewCell, Reusable {

    // MARK: - UI

    private lazy var logoImage = UIImageView() &> {
        $0.contentMode = .scaleAspectFit
        $0.fixSize(width: 36, height: 36)
    }

    private lazy var titleLabel = UILabel() &> {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var urlLabel = UILabel() &> {
        $0.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12))
        $0.adjustsFontForContentSizeCategory = true
    }

    // MARK: - Properties

    var viewModel: RssSourceViewModel? {
        didSet {
            guard let vm = viewModel else {
                return
            }

            logoImage.image = nil
            titleLabel.text = vm.source.title
            urlLabel.text = vm.source.url.absoluteString

            disposeBag = DisposeBag {
                vm.isSelected.map({ $0 ? .checkmark : .none }).bind(to: rx.accessoryType)
                vm.icon.drive(logoImage.rx.image)
            }
        }
    }

    // MARK: - Fields

    private var disposeBag = DisposeBag()

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

        let stackView = UIStackView(arrangedSubviews: [titleLabel, urlLabel]) &> {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
        }

        addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            logoImage.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        ])

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor)
        ])
    }
}
