//
//  RssSourceCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Nuke
import Reusable
import RxSwift
import UIKit

final class RssSourceCell: UITableViewCell, NibReusable {

    // MARK: - Outlets

    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!

    // MARK: - Properties

    var viewModel: RssSourceViewModel? {
        didSet {
            guard let vm = viewModel else {
                return
            }

            disposeBag = DisposeBag {
                vm.isSelected.map({ $0 ? .checkmark : .none }).bind(to: rx.accessoryType)
            }

            titleLabel.text = vm.source.title
            urlLabel.text = vm.source.url
            logoImage.image = nil

            guard let icon = vm.source.icon, let iconUrl = URL(string: icon) else {
                logoImage.image = nil
                return
            }

            Nuke.loadImage(with: iconUrl, into: logoImage)
        }
    }

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        // no pre-defined text style matches, so creating the font in code is needed
        urlLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12))
        urlLabel.adjustsFontForContentSizeCategory = true
    }
}
