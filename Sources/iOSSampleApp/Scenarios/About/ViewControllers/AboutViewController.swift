//
//  AboutViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxSwift
import UIKit

protocol AboutViewControllerDelegate: AnyObject {
    /**
     Invoked when user naviages back from the About screen
     */
    func aboutViewControllerDismissed()
    /**
     Invoked when user requests the list of used open source libraries
     */
    func userDidRequestLibraries()
    /**
     Invoked when user requests the authors info
     */
    func userDidRequestAuthorsInfo()
    /**
     Invoked when user requests the authors blog
     */
    func userDidRequestAuthorsBlog()
}

enum AboutMenuItem: Int {
    case libraries
    case aboutAuthor
    case authorsBlog
}

final class AboutViewController: UITableViewController, AboutStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var librariesLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var blogLabel: UILabel!

    // MARK: - Properties

    var viewModel: AboutViewModel!

    weak var delegate: AboutViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    // MARK: - Setup

    func setupUI() {
        title = L10n.about
        authorLabel.text = L10n.author
        librariesLabel.text = L10n.libraries
        blogLabel.text = L10n.blog

        titleLabel.text = viewModel.appName
        versionLabel.text = viewModel.appVersion
    }

    private func setupBinding() {
        tableView.rx.itemSelected.compactMap({ AboutMenuItem(rawValue: $0.row) }).withUnretained(self).bind { owner, menuItem in
            switch menuItem {
            case .libraries:
                owner.delegate?.userDidRequestLibraries()
            case .aboutAuthor:
                owner.delegate?.userDidRequestAuthorsInfo()
            case .authorsBlog:
                owner.delegate?.userDidRequestAuthorsBlog()
            }
        }.disposed(by: disposeBag)
    }

    deinit {
        delegate?.aboutViewControllerDismissed()
    }
}
