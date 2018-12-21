//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CRToast
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

protocol FeedViewControllerDelegeate: AnyObject {
    func userDidRequestItemDetail(item: RssItem)
    func userDidRequestSetup()
    func userDidRequestAbout()
}

final class FeedViewController: UIViewController, FeedStoryboardLodable, ToastCapable {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: FeedViewModel!
    weak var delegate: FeedViewControllerDelegeate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let refreshControl: UIRefreshControl
    private let setupButton: UIBarButtonItem
    private let aboutButton: UIBarButtonItem

    required init?(coder aDecoder: NSCoder) {
        refreshControl = UIRefreshControl()
        setupButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: nil, action: nil)
        aboutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "About"), style: .plain, target: nil, action: nil)
        aboutButton.accessibilityIdentifier = "about"

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = viewModel.title
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: L10n.pullToRefresh)

        navigationItem.leftBarButtonItem = setupButton
        navigationItem.rightBarButtonItem = aboutButton
    }

    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.modelSelected(RssItem.self).subscribe(onNext: { [weak self] item in self?.delegate?.userDidRequestItemDetail(item: item) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)

        setupButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequestSetup() }).disposed(by: disposeBag)
        aboutButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequestAbout() }).disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: FeedCell.self)

        let feed = viewModel.feed.materialize()
        feed.observeOn(MainScheduler.instance).errors().subscribe(onNext: { [weak self] error in
            switch error {
            case let rssError as RssError:
                self?.showErrorToast(message: rssError.description)
            default:
                self?.showErrorToast(message: L10n.networkProblem)
            }
        }).disposed(by: disposeBag)
        feed.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() }).disposed(by: disposeBag)

        feed.elements()
            .bind(to: tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
