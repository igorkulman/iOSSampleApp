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

final class SourceSelectionViewController: UIViewController {

    // MARK: - UI

    private lazy var tableView = UITableView() &> {
        $0.rowHeight = 60
        $0.tableFooterView = UIView()
    }

    private lazy var doneButton = UIBarButtonItem() &> {
        $0.title = NSLocalizedString("done", comment: "")
        $0.style = .plain
        $0.accessibilityIdentifier = "done"
    }

    private lazy var addCustomButton = UIBarButtonItem() &> {
        $0.title = NSLocalizedString("add_custom", comment: "")
        $0.style = .plain
    }

    private lazy var searchController = UISearchController()

    // MARK: - Properties

    let viewModel: SourceSelectionViewModel

    weak var delegate: SourceSelectionViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    init(viewModel: SourceSelectionViewModel) {
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
        title = NSLocalizedString("select_source", comment: "")
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addCustomButton

        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.estimatedRowHeight = 0
    }

    private func setupBinding() {
        tableView.rx.modelSelected(RssSourceViewModel.self).withUnretained(self).bind { owner, source in owner.viewModel.toggleSource(source: source) }.disposed(by: disposeBag)
        tableView.rx.itemSelected.withUnretained(self).bind { owner, indexPath in owner.tableView.deselectRow(at: indexPath, animated: true) }.disposed(by: disposeBag)
        viewModel.isValid.drive(doneButton.rx.isEnabled).disposed(by: disposeBag)
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
            .drive(tableView.rx.items(cellIdentifier: RssSourceCell.reuseIdentifier, cellType: RssSourceCell.self)) { _, element, cell in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SourceSelectionViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: SourceSelectionViewController(viewModel: SourceSelectionViewModel(settingsService: UserDefaultsSettingsService()))).asPreview()
    }
}
#endif
