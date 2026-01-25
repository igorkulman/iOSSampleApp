//
//  LibrariesViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

final class LibrariesViewController: UITableViewController {
    private static let cellIdentifier = "LibraryCell"

    // MARK: - Properties

    private let viewModel: LibrariesViewModel

    // MARK: - Fields

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
        title = String(localized: .libraries)
    }

    private func setupData() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.allowsSelection = false
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.libraries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        let library = viewModel.libraries[indexPath.row]

        cell.contentConfiguration = UIListContentConfiguration.subtitleCell() &> {
            $0.text = library.title
            $0.secondaryText = library.license
        }

        return cell
    }
}

#Preview {
    LibrariesViewController(viewModel: LibrariesViewModel())
}
