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
import RxBlocking
import RxSwift
import RxTest

class CustomSourceViewModelTests: QuickSpec {
    override func spec() {
        describe("CustomSourceViewModel") {
            context("with empty data") {
                let vm = CustomSourceViewModel()

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(false))
                }
            }

            context("with valid data") {
                let vm = CustomSourceViewModel()
                vm.title.accept("Coding Journal")
                vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                vm.url.accept("https://blog.kulman.sk")

                it("should validate OK") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(true))
                }
            }

            context("with missing URL") {
                let vm = CustomSourceViewModel()
                vm.title.accept("Coding Journal")
                vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                vm.url.accept(nil)

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(false))
                }
            }

            context("with invalid URL") {
                let vm = CustomSourceViewModel()
                vm.title.accept("Coding Journal")
                vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                vm.url.accept("blog")

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(false))
                }
            }

            context("with invalid RSS URL") {
                let vm = CustomSourceViewModel()
                vm.title.accept("Coding Journal")
                vm.rssUrl.accept("dss")
                vm.url.accept("https://blog.kulman.sk")

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(false))
                }
            }

            context("with missing title") {
                let vm = CustomSourceViewModel()
                vm.title.accept(nil)
                vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                vm.url.accept("https://blog.kulman.sk")

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()).to(equal(false))
                }
            }
        }
    }
}
