//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
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

    // MARK: - UI

    private lazy var tableView = UITableView() &> {
        $0.estimatedRowHeight = 0
        $0.rowHeight = 100
        $0.refreshControl = refreshControl
        $0.tableFooterView = UIView()
    }

    private lazy var refreshControl = UIRefreshControl() &> {
        $0.attributedTitle = NSAttributedString(string: NSLocalizedString("pull_to_refresh", comment: ""))
    }

    private lazy var setupButton = UIBarButtonItem() &> {
        $0.image = .settings
        $0.style = .plain
    }

    private lazy var aboutButton = UIBarButtonItem() &> {
        $0.image = .about
        $0.style = .plain
        $0.accessibilityIdentifier = "about"
    }

    // MARK: - Properties

    weak var delegate: FeedViewControllerDelegeate?

    // MARK: - Fields

    private let viewModel: FeedViewModel
    private var disposeBag = DisposeBag()

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        setupBinding()
        setupData()
    }

    private func setupUI() {
        title = viewModel.title

        navigationItem.leftBarButtonItem = setupButton
        navigationItem.rightBarButtonItem = aboutButton
    }

    private func setupBinding() {
        tableView.rx.modelSelected(RssItem.self).withUnretained(self).bind { owner, item in owner.delegate?.userDidRequestItemDetail(item: item) }.disposed(by: disposeBag)
        tableView.rx.itemSelected.withUnretained(self).bind { owner, indexPath in owner.tableView.deselectRow(at: indexPath, animated: true) }.disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)

        setupButton.rx.tap.withUnretained(self).bind { owner, _ in owner.delegate?.userDidRequestSetup() }.disposed(by: disposeBag)
        aboutButton.rx.tap.withUnretained(self).bind { owner, _ in owner.delegate?.userDidRequestAbout() }.disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: FeedCell.self)

        // announcing errors with a toast
        viewModel.onError.drive(onNext: { [weak self] error in
            guard let self = self else {
                return
            }
            switch error {
            case let rssError as RssError:
                self.showErrorToast(message: rssError.description)
            default:
                self.showErrorToast(message: NSLocalizedString("network_problem", comment: ""))
            }
        }).disposed(by: disposeBag)

        // refresh is considered finished when new data arrives or when the request fails
        Driver.merge(
            viewModel.feed.map({ _ in Void() }),
            viewModel.onError.map({ _ in Void() })
        )
        .drive(onNext: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        })
        .disposed(by: disposeBag)

        viewModel.feed
            .drive(tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
final class PreviewDataService: DataService {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
        onCompletion(.success([
            RssItem(title: "Post 1", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date()),
            RssItem(title: "Post 2", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date()),
            RssItem(title: "Post 3", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date())
        ]))
    }
}
final class PreviewSettingsService: SettingsService {
    var selectedSource: RssSource? = RssSource(
        title: "Hacker News",
        url: URL(string: "https://news.ycombinator.com")!,
        rss: URL(string: "https://news.ycombinator.com/rss")!,
        icon: URL("https://upload.wikimedia.org/wikipedia/commons/d/d5/Y_Combinator_Logo_400.gif")!
    )
}

struct FeedViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: FeedViewController(viewModel: FeedViewModel(dataService: PreviewDataService(), settingsService: PreviewSettingsService()))).asPreview()
    }
}
#endif
