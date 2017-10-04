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

class FeedViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: FeedViewModel!

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let refreshControl: UIRefreshControl

    required init?(coder aDecoder: NSCoder) {
        refreshControl = UIRefreshControl()

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
        title = "feed".localized
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "x")
    }

    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)
        viewModel.feed.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() }).disposed(by: disposeBag)
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
