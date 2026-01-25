//
//  SourceSelectionViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Observation
import OSLog

@Observable
final class SourceSelectionViewModel {

    // MARK: - Properties

    private(set) var sources: [RssSourceViewModel] = []
    var filter: String? {
        didSet {
            updateFilteredSources()
        }
    }

    var isValid: Bool {
        allSources.filter { $0.isSelected }.count == 1
    }

    // MARK: - Fields

    private var allSources: [RssSourceViewModel] = []
    private let settingsService: SettingsService

    init(settingsService: SettingsService) {
        self.settingsService = settingsService

        Logger.data.debug("Loading bundled sources")

        let jsonData = Bundle.main.loadFile(filename: "sources.json")!

        let jsonDecoder = JSONDecoder()
        let all = (try! jsonDecoder.decode(Array<RssSource>.self, from: jsonData)).map({ RssSourceViewModel(source: $0) })

        allSources = all
        updateFilteredSources()

        // selecting again from feed
        if let selected = settingsService.selectedSource {
            if let index = allSources.firstIndex(where: { $0.source == selected }) { // pre-selecting the current source
                allSources[index].isSelected = true
            } else { // using a custom source
                let vm = RssSourceViewModel(source: selected)
                vm.isSelected = true
                allSources.insert(vm, at: 0)
            }
        }

        updateFilteredSources()
    }

    // MARK: - Actions

    func toggleSource(source: RssSourceViewModel) {
        let selected = source.isSelected

        allSources.forEach {
            $0.isSelected = false
        }

        source.isSelected = !selected
        updateFilteredSources()
    }

    func addNewSource(source: RssSource) {
        let rssSourceViewModel = RssSourceViewModel(source: source)
        allSources.insert(rssSourceViewModel, at: 0)
        toggleSource(source: rssSourceViewModel)
    }

    func saveSelectedSource() -> Bool {
        guard let selected = allSources.first(where: { $0.isSelected }) else {
            Logger.data.error("Cannot save, no source selected")
            return false
        }

        settingsService.selectedSource = selected.source
        return true
    }

    // MARK: - Private

    private func updateFilteredSources() {
        if let filter = filter, !filter.isEmpty {
            sources = allSources.filter({ $0.source.title.lowercased().contains(filter.lowercased()) })
        } else {
            sources = allSources
        }
    }
}
