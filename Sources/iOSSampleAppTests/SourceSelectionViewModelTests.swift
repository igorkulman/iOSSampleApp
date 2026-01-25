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

struct SourceSelectionViewModelTests {

    @Test("Load default RSS sources when initialized")
    func testInitialSourcesLoad() throws {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // Then
        #expect(vm.sources.count == 4)
        #expect(vm.sources[0].source.title == "Coding Journal")
        #expect(vm.sources[1].source.title == "Hacker News")
        #expect(!vm.sources[0].isSelected)
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

        // Then
        #expect(vm.sources.count == 4)
        #expect(vm.sources[0].source.title == "Coding Journal")
        #expect(vm.sources[0].isSelected)
        #expect(!vm.sources[1].isSelected)
    }

    @Test("Add new source and make it selected")
    func testAddNewSource() throws {
        // Given
        let settingsService = SettingsServiceMock()
        let vm = SourceSelectionViewModel(settingsService: settingsService)

        // When
        vm.addNewSource(source: RssSource(
            title: "Example",
            url: URL(string: "http://example.com")!,
            rss: URL(string: "http://example.com")!,
            icon: nil
        ))

        // Then
        #expect(vm.sources.count == 5)
        #expect(vm.sources[0].isSelected)
        #expect(vm.sources[0].source.title == "Example")
        #expect(!vm.sources[1].isSelected)
    }

    @Test("Toggle source selection")
    func testToggleSource() throws {
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
        vm.toggleSource(source: vm.sources[2])

        // Then
        #expect(!vm.sources[0].isSelected)
        #expect(!vm.sources[1].isSelected)
        #expect(vm.sources[2].isSelected)
        #expect(!vm.sources[3].isSelected)
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
        vm.toggleSource(source: vm.sources[2])

        // When
        let result = vm.saveSelectedSource()

        // Then
        #expect(result)
        #expect(settingsService.selectedSource == vm.sources[2].source)
    }
}
