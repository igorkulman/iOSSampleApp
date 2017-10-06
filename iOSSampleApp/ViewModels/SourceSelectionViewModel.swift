//
//  SourceSelectionViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger

class SourceSelectionViewModel {

    // MARK: - Properties

    let sources: Observable<[RssSourceViewModel]>
    let filter = Variable<String?>(nil)
    let isValid: Observable<Bool>

    // MARK: - Fields

    private let allSources = Variable<[RssSourceViewModel]>([])
    private let settingsService: SettingsService
    private var disposeBag = DisposeBag()

    init(settingsService: SettingsService) {
        self.settingsService = settingsService

        Log.debug?.message("Loading sources")

        let jsonData = Bundle.loadFile(filename: "sources.json")!

        let jsonDecoder = JSONDecoder()
        let all = (try! jsonDecoder.decode(Array<RssSource>.self, from: jsonData)).map({ RssSourceViewModel(source: $0) })

        sources = Observable.combineLatest(allSources.asObservable(), filter.asObservable()) {
            (all: [RssSourceViewModel], filter: String?) -> [RssSourceViewModel] in
            if let filter = filter, !filter.isEmpty {
                return all.filter({ $0.source.title.lowercased().contains(filter.lowercased()) })
            } else {
                return all
            }
        }

        isValid = sources.asObservable().flatMap { Observable.combineLatest($0.map { $0.isSelected.asObservable() }) }.map({ $0.filter({ $0 }).count == 1 })

        allSources.value.append(contentsOf: all)

        // selecting again from feed
        if let selected = settingsService.selectedSource {
            if let index = allSources.value.index(where: { $0.source == selected }) { // pre-selecting the current source
                allSources.value[index].isSelected.value = true
            } else { // using a custom source
                let vm = RssSourceViewModel(source: selected)
                vm.isSelected.value = true
                allSources.value.insert(vm, at: 0)
            }
        }
    }

    // MARK: - Actions

    func toggleSource(source: RssSourceViewModel) {
        let selected = source.isSelected.value

        for s in allSources.value {
            s.isSelected.value = false
        }

        source.isSelected.value = !selected
    }

    func addNewSource(source: RssSource) {
        let vm = RssSourceViewModel(source: source)
        allSources.value.insert(vm, at: 0)
        toggleSource(source: vm)
    }

    func saveSelectedSource() -> Bool {
        guard let selected = allSources.value.first(where: { $0.isSelected.value }) else {
            Log.error?.message("Cannot save, no source selected")
            return false
        }

        settingsService.selectedSource = selected.source
        return true
    }
}
