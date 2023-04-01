//
//  LibrariesViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Resources
import RxSwift
import UIKit

final class LibrariesViewController: UITableViewController {

    // MARK: - Properties

    private let viewModel: LibrariesViewModel

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    init(viewModel: LibrariesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    private func setupUI() {
        title = L10n.libraries
    }

    private func setupData() {
        tableView.dataSource = nil
        tableView.register(cellType: LibraryCell.self)

        viewModel.libraries.bind(to: tableView.rx.items(cellIdentifier: LibraryCell.reuseIdentifier, cellType: LibraryCell.self)) { _, element, cell in
            let (name, licenseName) = element
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = licenseName
        }.disposed(by: disposeBag)
    }
}
