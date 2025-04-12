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
import RxSwift

struct CustomSourceViewModelTests {

    @Test("Empty data should not be valid")
    func testEmptyDataValidation() throws {
        // Given
        let vm = CustomSourceViewModel()

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == false)
    }

    @Test("Valid data should validate correctly")
    func testValidDataValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title.accept("Coding Journal")
        vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
        vm.url.accept("https://blog.kulman.sk")

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == true)
    }

    @Test("Missing URL should not validate")
    func testMissingUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title.accept("Coding Journal")
        vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
        vm.url.accept(nil)

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == false)
    }

    @Test("Invalid URL should not validate")
    func testInvalidUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title.accept("Coding Journal")
        vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
        vm.url.accept("blog")

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == false)
    }

    @Test("Invalid RSS URL should not validate")
    func testInvalidRssUrlValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title.accept("Coding Journal")
        vm.rssUrl.accept("dss")
        vm.url.accept("https://blog.kulman.sk")

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == false)
    }

    @Test("Missing title should not validate")
    func testMissingTitleValidation() throws {
        // Given
        let vm = CustomSourceViewModel()
        vm.title.accept(nil)
        vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
        vm.url.accept("https://blog.kulman.sk")

        // When
        let isValid = try vm.isValid.toBlocking().first()!

        // Then
        #expect(isValid == false)
    }
}
