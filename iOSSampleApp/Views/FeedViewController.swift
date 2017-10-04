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
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupData() {
        tableView.register(cellType: FeedCell.self)
        
        viewModel.feed
            .bind(to: tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: UITableViewCell.self)) { _, element, cell in
                if let cell = cell as? FeedCell {
                    cell.model = element
                }
            }
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
