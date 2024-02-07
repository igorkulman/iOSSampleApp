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

final class AboutViewController: UITableViewController {

    // MARK: - UI

    private lazy var titleLabel = UILabel() &> {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    private lazy var versionLabel = UILabel() &> {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
    }

    private lazy var logoImageView = UIImageView() &> {
        $0.image = .logo
        $0.contentMode = .scaleAspectFit
        $0.fixSize(width: 48, height: 48)
    }

    private lazy var headerView = UIView() &> {
        let textsStackView = UIStackView(arrangedSubviews: [titleLabel, versionLabel]) &> {
            $0.axis = .vertical
        }

        let stackView = UIStackView(arrangedSubviews: [logoImageView, textsStackView]) &> {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 8
        }

        stackView.pin(to: $0, insets: .init(top: 0, left: 0, bottom: 16, right: 0))
    }

    // MARK: - Properties

    private let viewModel: AboutViewModel

    weak var delegate: AboutViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    // MARK: - Setup

    init(viewModel: AboutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    private func setupUI() {
        title = NSLocalizedString("about", comment: "")

        titleLabel.text = viewModel.appName
        versionLabel.text = viewModel.appVersion
    }

    private func setupBinding() {
        tableView.dataSource = nil
        tableView.register(cellType: AboutCell.self)

        Observable.just(AboutMenuItem.allCases).bind(to: tableView.rx.items(cellIdentifier: AboutCell.reuseIdentifier, cellType: AboutCell.self)) { _, element, cell in
            cell.model = element
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(AboutMenuItem.self).withUnretained(self).bind { owner, menuItem in
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct AboutViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: AboutViewController(viewModel: AboutViewModel())).asPreview()
    }
}
#endif
