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

protocol SourceSelectionViewControllerDelegate: class {
    func sourceSelectionViewControllerDidFinish()
    func userDidRequestCustomSource()
}

class SourceSelectionViewController: UIViewController, SetupStoryboardLodable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: SourceSelectionViewModel!
    weak var delegate: SourceSelectionViewControllerDelegate?
    
    // MARK: - Fields
    
    private var disposeBag = DisposeBag()
    
    private let doneButton: UIBarButtonItem
    private let addCustomButton: UIBarButtonItem
    private let searchController: UISearchController
    
    required init?(coder aDecoder: NSCoder) {
        doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: nil, action: nil)
        addCustomButton = UIBarButtonItem(title: "add_custom".localized, style: .plain, target: nil, action: nil)
        searchController = UISearchController(searchResultsController: nil)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    private func setupUI() {
        title = "select_source".localized
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addCustomButton
        
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        tableView.rx.modelSelected(RssSourceViewModel.self).subscribe(onNext: { [weak self] source in self?.viewModel.toggleSource(source: source) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.saveSelectedSource()
            self?.delegate?.sourceSelectionViewControllerDidFinish()
            
        }).disposed(by: disposeBag)
        addCustomButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequestCustomSource() }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.throttle(0.1, scheduler: MainScheduler.instance).bind(to: viewModel.filter).disposed(by: disposeBag)
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in self?.searchController.searchBar.setShowsCancelButton(true, animated: true) }).disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] in
            self?.searchController.searchBar.resignFirstResponder()
            self?.searchController.searchBar.setShowsCancelButton(false, animated: true)
            self?.viewModel.filter.value = nil
            self?.searchController.searchBar.text = nil
        }).disposed(by: disposeBag)
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
