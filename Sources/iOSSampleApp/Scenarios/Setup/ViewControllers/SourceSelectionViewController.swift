//
//  SourceSelectionViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol SourceSelectionViewControllerDelegate: AnyObject {
    /**
     Invoked when the user finished setting the RSS source
     */
    func sourceSelectionViewControllerDidFinish()
    /**
     Invoked when user requests adding a new custom source
     */
    func userDidRequestCustomSource()
}

final class SourceSelectionViewController: UIViewController, SetupStoryboardLodable {

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
        doneButton = UIBarButtonItem(title: L10n.done, style: .plain, target: nil, action: nil)
        doneButton.accessibilityIdentifier = "done"
        addCustomButton = UIBarButtonItem(title: L10n.addCustom, style: .plain, target: nil, action: nil)
        searchController = UISearchController(searchResultsController: nil)

        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = L10n.selectSource
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addCustomButton

        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.estimatedRowHeight = 0
    }

    private func setupBinding() {
        tableView.rx.modelSelected(RssSourceViewModel.self).withUnretained(self).bind { owner, source in owner.viewModel.toggleSource(source: source) }.disposed(by: disposeBag)
        tableView.rx.itemSelected.withUnretained(self).bind { owner, indexPath in owner.tableView.deselectRow(at: indexPath, animated: true) }.disposed(by: disposeBag)
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        doneButton.rx.tap.withUnretained(self).bind { owner, _ in
            if owner.viewModel.saveSelectedSource() {
                owner.delegate?.sourceSelectionViewControllerDidFinish()
            }

        }.disposed(by: disposeBag)
        addCustomButton.rx.tap.withUnretained(self).bind { owner, _ in owner.delegate?.userDidRequestCustomSource() }.disposed(by: disposeBag)

        searchController.searchBar.rx.text.throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance).bind(to: viewModel.filter).disposed(by: disposeBag)
        searchController.searchBar.rx.textDidBeginEditing.withUnretained(self).bind { owner, _ in owner.searchController.searchBar.setShowsCancelButton(true, animated: true) }.disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked.withUnretained(self).bind { owner, _ in
            owner.searchController.searchBar.resignFirstResponder()
            owner.searchController.searchBar.setShowsCancelButton(false, animated: true)
            owner.viewModel.filter.accept(nil)
            owner.searchController.searchBar.text = nil
        }.disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: RssSourceCell.self)

        viewModel.sources
            .bind(to: tableView.rx.items(cellIdentifier: RssSourceCell.reuseIdentifier, cellType: RssSourceCell.self)) { _, element, cell in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
    }
}
