//
//  RssSourceCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Nuke
import Reusable
import RxNuke
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

            disposeBag = DisposeBag()

            titleLabel.text = vm.source.title
            urlLabel.text = vm.source.url
            vm.isSelected.asObservable().subscribe(onNext: { [weak self] selected in
                self?.accessoryType = selected ? .checkmark : .none
            }).disposed(by: disposeBag)
            logoImage.image = nil
            if let icon = vm.source.icon, let iconUrl = URL(string: icon) {
                ImagePipeline.shared.rx.loadImage(with: iconUrl)
                    .subscribe(onSuccess: { [weak self] in self?.logoImage.image = $0.image })
                    .disposed(by: disposeBag)
            }
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
