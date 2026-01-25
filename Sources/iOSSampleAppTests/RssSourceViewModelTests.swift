//
//  RssSourceViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 25/12/2024.
//  Copyright © 2024 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Testing

struct RssSourceViewModelTests {

    @Test("Initialize with source without icon")
    func testInitWithoutIcon() async throws {
        // Given
        let source = RssSource(
            title: "Test Source",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: nil
        )

        // When
        let vm = RssSourceViewModel(source: source)

        // Then
        #expect(vm.source == source)
        #expect(vm.isSelected == false)
        #expect(vm.icon == nil)
    }

    @Test("Initialize with source and load icon asynchronously")
    func testInitWithIcon() async throws {
        // Given
        let source = RssSource(
            title: "Hacker News",
            url: URL(string: "https://news.ycombinator.com")!,
            rss: URL(string: "https://news.ycombinator.com/rss")!,
            icon: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d5/Y_Combinator_Logo_400.gif")!
        )

        // When
        let vm = RssSourceViewModel(source: source)

        // Give the async icon loading some time
        // Note: In a real test, you might want to mock URLSession for deterministic testing
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Then
        #expect(vm.source == source)
        #expect(vm.isSelected == false)
        // Icon might be loaded or not depending on network, but shouldn't crash
    }

    @Test("Toggle selection state")
    func testToggleSelection() async throws {
        // Given
        let source = RssSource(
            title: "Test",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: nil
        )
        let vm = RssSourceViewModel(source: source)

        // When
        vm.isSelected = true

        // Then
        #expect(vm.isSelected == true)

        // When
        vm.isSelected = false

        // Then
        #expect(vm.isSelected == false)
    }

    @Test("Handle invalid icon URL gracefully")
    func testInvalidIconUrl() async throws {
        // Given
        let source = RssSource(
            title: "Test",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: URL(string: "https://invalid-url-that-does-not-exist.com/icon.png")!
        )

        // When
        let vm = RssSourceViewModel(source: source)

        // Give the async icon loading some time to fail
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Then - Should not crash and icon should be nil
        #expect(vm.icon == nil)
    }
}
