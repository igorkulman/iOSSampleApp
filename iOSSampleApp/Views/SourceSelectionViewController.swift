//
//  SourceSelectionViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SourceSelectionViewController: UIViewController, SetupStoryboardLodable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: SourceSelectionViewModel!
    
    // MARK: - Fields
    
    private var disposeBag = DisposeBag()
    private let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    private func setupUI() {
        title = "select_source".localized
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        tableView.rx.modelSelected(RssSourceViewModel.self).subscribe(onNext: { [weak self] source in self?.viewModel.toggleSource(source: source) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func setupData() {
        tableView.register(cellType: RssSourceCell.self)
        
        viewModel.sources
            .bind(to: tableView.rx.items(cellIdentifier: RssSourceCell.reuseIdentifier, cellType: UITableViewCell.self)) { _, element, cell in
                if let cell = cell as? RssSourceCell {
                    cell.viewModel = element
                }
            }
            .disposed(by: disposeBag)
    }
}
