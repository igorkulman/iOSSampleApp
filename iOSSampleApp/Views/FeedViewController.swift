//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CRToast

protocol FeedViewControllerDelegeate: class {
    func userDidRequestItemDetail(item: RssItem)
    func userDidRequesrtSetup()
}

class FeedViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: FeedViewModel!
    weak var delegate: FeedViewControllerDelegeate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let refreshControl: UIRefreshControl
    private let setupButton: UIBarButtonItem

    required init?(coder aDecoder: NSCoder) {
        refreshControl = UIRefreshControl()
        setupButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)

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
        refreshControl.attributedTitle = NSAttributedString(string: "pull_to_refresh".localized)
        navigationItem.rightBarButtonItem = setupButton
    }

    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.modelSelected(RssItem.self).subscribe(onNext: { [weak self] item in self?.delegate?.userDidRequestItemDetail(item: item) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)
        viewModel.feed.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] items in
            self?.refreshControl.endRefreshing()
            if items.count == 0 {
                CRToastManager.showErrorNotification(title: "network_problem".localized)
            }
        }).disposed(by: disposeBag)
        setupButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequesrtSetup() }).disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: FeedCell.self)

        viewModel.feed
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
