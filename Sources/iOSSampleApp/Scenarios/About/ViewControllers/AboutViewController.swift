//
//  AboutViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

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

    private static let cellIdentifier = "AboutCell"

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
        setupData()
    }

    private func setupUI() {
        title = String(localized: .about)

        titleLabel.text = viewModel.appName
        versionLabel.text = viewModel.appVersion
    }

    private func setupData() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AboutMenuItem.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        let menuItem = AboutMenuItem.allCases[indexPath.row]

        cell.contentConfiguration = UIListContentConfiguration.cell() &> {
            $0.text = menuItem.title
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let menuItem = AboutMenuItem.allCases[indexPath.row]
        switch menuItem {
        case .libraries:
            delegate?.userDidRequestLibraries()
        case .aboutAuthor:
            delegate?.userDidRequestAuthorsInfo()
        case .authorsBlog:
            delegate?.userDidRequestAuthorsBlog()
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    // MARK: - Lifecycle

    deinit {
        delegate?.aboutViewControllerDismissed()
    }
}

#Preview {
    AboutViewController(viewModel: AboutViewModel())
}
