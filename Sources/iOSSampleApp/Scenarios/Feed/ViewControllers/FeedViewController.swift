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

final class FeedViewController: UIViewController, FeedStoryboardLodable, ToastCapable {

    // MARK: - UI

    private lazy var tableView: UITableView = .init() &> {
        $0.estimatedRowHeight = 0
        $0.rowHeight = 100
        $0.refreshControl = refreshControl
        $0.tableFooterView = UIView()
    }

    private lazy var refreshControl: UIRefreshControl = .init() &> {
        $0.attributedTitle = NSAttributedString(string: L10n.pullToRefresh)
    }

    private lazy var setupButton: UIBarButtonItem = .init() &> {
        $0.image = #imageLiteral(resourceName: "Settings")
        $0.style = .plain
    }

    private lazy var aboutButton: UIBarButtonItem = .init() &> {
        $0.image = #imageLiteral(resourceName: "About")
        $0.style = .plain
        $0.accessibilityIdentifier = "about"
    }

    // MARK: - Properties

    private let viewModel: FeedViewModel

    weak var delegate: FeedViewControllerDelegeate?

    // MARK: - Fields

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

        tableView.pin(to: view)
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
        viewModel.onError.withUnretained(self).bind { owner, error in
            switch error {
            case let rssError as RssError:
                owner.showErrorToast(message: rssError.description)
            default:
                owner.showErrorToast(message: L10n.networkProblem)
            }
        }.disposed(by: disposeBag)

        // refresh is considered finished when new data arrives or when the request fails
        Observable.merge(viewModel.feed.map({ _ in Void() }), viewModel.onError.map({ _ in Void() })).withUnretained(self).bind { owner, _ in owner.refreshControl.endRefreshing() }.disposed(by: disposeBag)

        viewModel.feed
            .bind(to: tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
    }
}
