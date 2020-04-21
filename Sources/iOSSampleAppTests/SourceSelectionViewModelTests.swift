//
//  CustomSourceViewModelTest.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import RxSwift

class SourceSelectionViewModelTests: QuickSpec {
    override func spec() {
        describe("SourceSelectionViewModel") {
            var vm: SourceSelectionViewModel!
            var settingsService: SettingsServiceMock!
            beforeEach {
                settingsService = SettingsServiceMock()
                vm = SourceSelectionViewModel(settingsService: settingsService)
            }

            context("when intialized") {
                it("should load default RSS sources") {
                    let sources = try! vm.sources.toBlocking().first()!
                    expect(sources.count) == 4
                    expect(sources[0].source.title) == "Coding Journal"
                    expect(sources[1].source.title) == "Hacker News"
                    expect(sources[2].source.title) == "The Verge"
                    expect(sources[3].source.title) == "Wired"
                    expect(sources[0].isSelected.value).to(beFalse())
                    expect(sources[1].isSelected.value).to(beFalse())
                    expect(sources[2].isSelected.value).to(beFalse())
                    expect(sources[3].isSelected.value).to(beFalse())
                }
            }

            context("when initialized and a feed already selected") {
                beforeEach {
                    settingsService = SettingsServiceMock()
                    settingsService.selectedSource = RssSource(title: "Coding Journal", url: "https://blog.kulman.sk", rss: "https://blog.kulman.sk/index.xml", icon: nil)
                    vm = SourceSelectionViewModel(settingsService: settingsService)
                }

                it("should pre-select that feed") {
                    let sources = try! vm.sources.toBlocking().first()!
                    expect(sources.count) == 4
                    expect(sources[0].source.title) == "Coding Journal"
                    expect(sources[0].isSelected.value).to(beTrue())
                    expect(sources[1].isSelected.value).to(beFalse())
                    expect(sources[2].isSelected.value).to(beFalse())
                    expect(sources[3].isSelected.value).to(beFalse())
                }
            }

            context("when a new source is added") {
                it("should be available, at firts position and selected") {
                    vm.addNewSource(source: RssSource(title: "Example", url: "http://example.com", rss: "http://example.com", icon: nil))
                    let sources = try! vm.sources.toBlocking().first()!
                    expect(sources.count) == 5
                    expect(sources[1].isSelected.value).to(beFalse())
                    expect(sources[2].isSelected.value).to(beFalse())
                    expect(sources[3].isSelected.value).to(beFalse())
                    expect(sources[4].isSelected.value).to(beFalse())
                    expect(sources[0].isSelected.value).to(beTrue())
                    expect(sources[0].source.title) == "Example"
                }
            }

            context("when initialized and a feed already selected") {
                beforeEach {
                    settingsService = SettingsServiceMock()
                    settingsService.selectedSource = RssSource(title: "Coding Journal", url: "https://blog.kulman.sk", rss: "https://blog.kulman.sk/index.xml", icon: nil)
                    vm = SourceSelectionViewModel(settingsService: settingsService)
                }

                it("should toggle the selection") {
                    let sources = try! vm.sources.toBlocking().first()!
                    vm.toggleSource(source: sources[2])
                    expect(sources[0].isSelected.value).to(beFalse())
                    expect(sources[1].isSelected.value).to(beFalse())
                    expect(sources[2].isSelected.value).to(beTrue())
                    expect(sources[3].isSelected.value).to(beFalse())
                }
            }

            context("when no source is selected") {
                it("should not be saved") {
                    expect(vm.saveSelectedSource()).to(beFalse())
                    expect(settingsService.selectedSource).to(beNil())
                }
            }

            context("when source is selected") {
                it("should be saved") {
                    let sources = try! vm.sources.toBlocking().first()!
                    vm.toggleSource(source: sources[2])
                    expect(vm.saveSelectedSource()).to(beTrue())
                    expect(settingsService.selectedSource) == sources[2].source
                }
            }
        }
    }
}
