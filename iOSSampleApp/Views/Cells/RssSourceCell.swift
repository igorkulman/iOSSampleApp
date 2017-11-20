//
//  RssSourceCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxNuke
import Nuke

class RssSourceCell: UITableViewCell, NibReusable {

    // MARK: - Outlets

    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!

    // MARK: - Properties

    var viewModel: RssSourceViewModel? {
        didSet {
            if let vm = viewModel {
                disposeBag = DisposeBag()

                titleLabel.text = vm.source.title
                urlLabel.text = vm.source.url
                vm.isSelected.asObservable().subscribe(onNext: { [weak self] selected in
                    self?.accessoryType = selected ? .checkmark : .none
                }).disposed(by: disposeBag)
                logoImage.image = nil
                if let icon = vm.source.icon, let iconUrl = URL(string: icon) {
                    Nuke.Manager.shared.loadImage(with: iconUrl)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { [weak self] in self?.logoImage.image = $0 })
                        .disposed(by: disposeBag)
                }
            }
        }
    }

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        urlLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12))
    }
}
