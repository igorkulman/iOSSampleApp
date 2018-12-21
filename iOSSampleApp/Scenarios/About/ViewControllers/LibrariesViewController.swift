//
//  LibrariesViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxSwift
import UIKit

final class LibrariesViewController: UITableViewController, AboutStoryboardLodable {

    // MARK: - Properties

    var viewModel: LibrariesViewModel!

    // MARK: - Fields

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = L10n.libraries
    }

    private func setupData() {
        viewModel.libraries.bind(to: tableView.rx.items(cellIdentifier: "LicensesCell", cellType: UITableViewCell.self)) { _, element, cell in
            let (name, licenseName) = element
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = licenseName
        }.disposed(by: disposeBag)
    }
}
