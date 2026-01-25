//
//  CustomSourceViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Testing

struct CustomSourceViewModelTests {

    @Test("Empty data should not be valid")
    func testEmptyDataValidation() throws {
        // Given
        let vm = CustomSourceViewModel()

        // Then
        #expect(vm.isValid == false)
    }

    @Test("Valid data should validate correctly")
    func testValidDataValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title = "Coding Journal"
        vm.rssUrl = "https://blog.kulman.sk/index.xml"
        vm.url = "https://blog.kulman.sk"

        // Then
        #expect(vm.isValid == true)
    }

    @Test("Missing URL should not validate")
    func testMissingUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title = "Coding Journal"
        vm.rssUrl = "https://blog.kulman.sk/index.xml"
        vm.url = nil

        // Then
        #expect(vm.isValid == false)
    }

    @Test("Invalid URL should not validate")
    func testInvalidUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title = "Coding Journal"
        vm.rssUrl = "https://blog.kulman.sk/index.xml"
        vm.url = "blog"

        // Then
        #expect(vm.isValid == false)
    }

    @Test("Invalid RSS URL should not validate")
    func testInvalidRssUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title = "Coding Journal"
        vm.rssUrl = "dss"
        vm.url = "https://blog.kulman.sk"

        // Then
        #expect(vm.isValid == false)
    }

    @Test("Missing title should not validate")
    func testMissingTitleValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title = nil
        vm.rssUrl = "https://blog.kulman.sk/index.xml"
        vm.url = "https://blog.kulman.sk"

        // Then
        #expect(vm.isValid == false)
    }
}
