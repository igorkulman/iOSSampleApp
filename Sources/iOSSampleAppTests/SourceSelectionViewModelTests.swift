//
//  SourceSelectionViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Testing
import RxSwift

struct SourceSelectionViewModelTests {

    @Test("Load default RSS sources when initialized")
    func testInitialSourcesLoad() throws {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // When
        let sources = try vm.sources.toBlocking().first()!

        // Then
        #expect(sources.count == 4)
        #expect(sources[0].source.title == "Coding Journal")
        #expect(sources[1].source.title == "Hacker News")
        #expect(!sources[0].isSelected.value)
    }

    @Test("Pre-select feed when already configured")
    func testPreselectedFeed() throws {
        // Given
        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Coding Journal",
            url: URL(string: "https://blog.kulman.sk")!,
            rss: URL(string: "https://blog.kulman.sk/index.xml")!,
            icon: nil
        )
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // When
        let sources = try vm.sources.toBlocking().first()!

        // Then
        #expect(sources.count == 4)
        #expect(sources[0].source.title == "Coding Journal")
        #expect(sources[0].isSelected.value)
        #expect(!sources[1].isSelected.value)
    }

    @Test("Add new source and make it selected")
    func testAddNewSource() throws {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // When
        vm.addNewSource(source: RssSource(
            title: "Example",
            url: URL(string:"http://example.com")!,
            rss: URL(string:"http://example.com")!,
            icon: nil
        ))

        // Then
        let sources = try vm.sources.toBlocking().first()!
        #expect(sources.count == 5)
        #expect(sources[0].isSelected.value)
        #expect(sources[0].source.title == "Example")
        #expect(!sources[1].isSelected.value)
    }

    @Test("Toggle source selection")
    func testToggleSource() throws {
        // Given
        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Coding Journal",
            url: URL(string:"https://blog.kulman.sk")!,
            rss: URL(string:"https://blog.kulman.sk/index.xml")!,
            icon: nil
        )
        let vm = SourceSelectionViewModel(settingsService: settingsService)
        let sources = try vm.sources.toBlocking().first()!

        // When
        vm.toggleSource(source: sources[2])

        // Then
        #expect(!sources[0].isSelected.value)
        #expect(!sources[1].isSelected.value)
        #expect(sources[2].isSelected.value)
        #expect(!sources[3].isSelected.value)
    }

    @Test("Cannot save when no source selected")
    func testSaveWhenNoSourceSelected() {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // When
        let result = vm.saveSelectedSource()

        // Then
        #expect(!result)
        #expect(settingsService.selectedSource == nil)
    }

    @Test("Successfully save when source selected")
    func testSaveWhenSourceSelected() throws {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)
        let sources = try vm.sources.toBlocking().first()!
        vm.toggleSource(source: sources[2])

        // When
        let result = vm.saveSelectedSource()

        // Then
        #expect(result)
        #expect(settingsService.selectedSource == sources[2].source)
    }
}
