//
//  SourceSelectionViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

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

    private static let cellIdentifier = "SourceCell"

    // MARK: - UI

    private lazy var tableView = UITableView() &> {
        $0.rowHeight = 60
        $0.tableFooterView = UIView()
        $0.delegate = self
    }

    private lazy var doneButton = UIBarButtonItem(
        title: String(localized: .done),
        primaryAction: UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.saveSelectedSource() {
                self.delegate?.sourceSelectionViewControllerDidFinish()
            }
        }
    ) &> {
        $0.accessibilityIdentifier = "done"
    }

    private lazy var addCustomButton = UIBarButtonItem(
        title: String(localized: .addCustom),
        primaryAction: UIAction { [weak self] _ in
            self?.delegate?.userDidRequestCustomSource()
        }
    )

    private lazy var searchController = UISearchController() &> {
        $0.searchBar.delegate = self
    }

    // MARK: - Properties

    let viewModel: SourceSelectionViewModel

    weak var delegate: SourceSelectionViewControllerDelegate?

    // MARK: - Fields

    private typealias DataSource = UITableViewDiffableDataSource<Section, RssSource>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RssSource>

    private enum Section {
        case main
    }

    private var dataSource: DataSource!

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
        setupData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.sources.map { $0.source })
        dataSource.apply(snapshot, animatingDifferences: true)

        doneButton.isEnabled = viewModel.isValid
    }

    private func setupUI() {
        title = String(localized: .selectSource)
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addCustomButton

        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.estimatedRowHeight = 0
    }

    private func setupData() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)

        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, source in
            guard let self = self else { return UITableViewCell() }

            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)

            cell.configurationUpdateHandler = { [weak self] cell, _ in
                guard let self = self,
                      let sourceVM = self.viewModel.sources.first(where: { $0.source == source }) else {
                    return
                }

                let config = UIListContentConfiguration.subtitleCell() &> {
                    $0.text = source.title
                    $0.secondaryText = source.url.absoluteString
                    $0.secondaryTextProperties.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12))
                    $0.image = sourceVM.icon  // Automatically updates when icon loads
                    $0.imageProperties.maximumSize = CGSize(width: 36, height: 36)
                    $0.imageProperties.reservedLayoutSize = CGSize(width: 36, height: 36)
                }
                cell.contentConfiguration = config
                cell.accessoryType = sourceVM.isSelected ? .checkmark : .none
            }

            cell.setNeedsUpdateConfiguration()

            return cell
        }
    }

}

// MARK: - UITableViewDelegate

extension SourceSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let source = dataSource.itemIdentifier(for: indexPath),
           let sourceVM = viewModel.sources.first(where: { $0.source == source }) {
            viewModel.toggleSource(source: sourceVM)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SourceSelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter = searchText.isEmpty ? nil : searchText
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        viewModel.filter = nil
        searchBar.text = nil
    }
}

#Preview {
    UINavigationController(rootViewController: SourceSelectionViewController(viewModel: SourceSelectionViewModel(settingsService: UserDefaultsSettingsService())))
}
