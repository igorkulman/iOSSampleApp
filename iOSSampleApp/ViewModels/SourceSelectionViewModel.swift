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
    
    private let allSources: [RssSourceViewModel]
    
    init() {
        Log.debug?.message("Loading sources")
        
        let jsonData = Bundle.loadFile(filename: "sources.json")!
        
        let jsonDecoder = JSONDecoder()
        let all = (try! jsonDecoder.decode(Array<RssSource>.self, from: jsonData)).map({ RssSourceViewModel(source: $0) })
        
        sources = filter.asObservable().map {
            (filter: String?) -> [RssSourceViewModel] in
            if let filter = filter, !filter.isEmpty {
                return all.filter({ $0.source.title.lowercased().contains(filter.lowercased()) })
            } else {
                return all
            }
        }
        
        isValid = sources.asObservable().flatMap { Observable.combineLatest($0.map { $0.isSelected.asObservable() }) }.map({$0.filter({$0}).count == 1})
        
        allSources = all
    }
    
    // MARK: - Actions
    
    func toggleSource(source: RssSourceViewModel) {
        for s in allSources.filter({$0.source.url != source.source.url}) {
            s.isSelected.value = false
        }
        
        source.isSelected.value = !source.isSelected.value
    }
    
    func saveSelectedSource() {
        
    }
}
