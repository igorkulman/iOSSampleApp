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
        tableView.rx.itemSelected.bind { [unowned self] indexPath in

            // instead of using the row umber directly converting them to an enum to use them in a safer way
            guard let menuItem = AboutMenuItem(rawValue: indexPath.row) else { fatalError("Invalid indexPath") }
            switch menuItem {
            case .libraries:
                self.delegate?.userDidRequestLibraries()
            case .aboutAuthor:
                self.delegate?.userDidRequestAuthorsInfo()
            case .authorsBlog:
                self.delegate?.userDidRequestAuthorsBlog()
            }
        }.disposed(by: disposeBag)
    }

    deinit {
        delegate?.aboutViewControllerDismissed()
    }
}
