//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

protocol FeedViewControllerDelegeate: AnyObject {
    /**
     Invoked when user requests showing RSS item detail

     - Parameter item: RSS item to show detail
     */
    func userDidRequestItemDetail(item: RssItem)
    /**
     Invoked when user requests starting the setup process again
     */
    func userDidRequestSetup()
    /**
     Invoked when user resuests the About screen
     */
    func userDidRequestAbout()
}

final class FeedViewController: UIViewController, ToastCapable {

    private static let cellIdentifier = "FeedCell"

    // MARK: - UI

    private lazy var tableView = UITableView() &> {
        $0.estimatedRowHeight = 0
        $0.rowHeight = 100
        $0.refreshControl = refreshControl
        $0.tableFooterView = UIView()
        $0.delegate = self
    }

    private lazy var refreshControl = UIRefreshControl() &> {
        $0.attributedTitle = NSAttributedString(string: String(localized: .pullToRefresh))
        $0.addAction(UIAction { [weak self] _ in
            self?.loadTask?.cancel()
            self?.loadTask = Task {
                await self?.viewModel.load()
            }
        }, for: .valueChanged)
    }

    private lazy var setupButton = UIBarButtonItem(
        image: .settings,
        primaryAction: UIAction { [weak self] _ in
            self?.delegate?.userDidRequestSetup()
        }
    )

    private lazy var aboutButton = UIBarButtonItem(
        image: .about,
        primaryAction: UIAction { [weak self] _ in
            self?.delegate?.userDidRequestAbout()
        }
    ) &> {
        $0.accessibilityIdentifier = "about"
    }

    // MARK: - Properties

    weak var delegate: FeedViewControllerDelegeate?

    // MARK: - Fields

    private typealias DataSource = UITableViewDiffableDataSource<Section, RssItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RssItem>

    private enum Section {
        case main
    }

    private let viewModel: FeedViewModel
    private var dataSource: DataSource!
    private var loadTask: Task<Void, Never>?

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        loadTask?.cancel()
    }

    // MARK: - Setup

    override func loadView() {
        let view = UIView()
        defer { self.view = view }

        tableView.pin(to: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.feed)
        dataSource.apply(snapshot, animatingDifferences: true)

        if !viewModel.isLoading {
            refreshControl.endRefreshing()
        }

        if let error = viewModel.error {
            viewModel.clearError()  // Clear to prevent duplicate toasts on layout passes
            switch error {
            case let rssError as RssError:
                showErrorToast(message: rssError.description)
            default:
                showErrorToast(message: String(localized: .networkProblem))
            }
        }
    }

    private func setupUI() {
        title = viewModel.title

        navigationItem.leftBarButtonItem = setupButton
        navigationItem.rightBarButtonItem = aboutButton
    }

    private func setupData() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)

        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)

            cell.contentConfiguration = UIListContentConfiguration.subtitleCell() &> {
                $0.text = item.title
                $0.secondaryText = item.description

                $0.textProperties.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 17, weight: .semibold))
                $0.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
                $0.secondaryTextProperties.numberOfLines = 3
            }

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = dataSource.itemIdentifier(for: indexPath) {
            delegate?.userDidRequestItemDetail(item: item)
        }
    }
}

#Preview {
    let settings = SettingsServiceMock()
    settings.selectedSource = RssSource(
        title: "Hacker News",
        url: URL(string: "https://news.ycombinator.com")!,
        rss: URL(string: "https://news.ycombinator.com/rss")!,
        icon: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d5/Y_Combinator_Logo_400.gif")!
    )
    return UINavigationController(rootViewController: FeedViewController(viewModel: FeedViewModel(dataService: DataServiceMock(), settingsService: settings)))
}
