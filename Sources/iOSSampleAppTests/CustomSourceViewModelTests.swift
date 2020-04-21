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

class CustomSourceViewModelTests: QuickSpec {
    override func spec() {
        describe("CustomSourceViewModel") {
            var vm: CustomSourceViewModel!
            beforeEach {
                vm = CustomSourceViewModel()
            }

            context("with empty data") {
                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()) == false
                }
            }

            context("with valid data") {
                beforeEach {
                    vm.title.accept("Coding Journal")
                    vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                    vm.url.accept("https://blog.kulman.sk")
                }

                it("should validate OK") {
                    expect(try! vm.isValid.toBlocking().first()) == true
                }
            }

            context("with missing URL") {
                beforeEach {
                    vm.title.accept("Coding Journal")
                    vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                    vm.url.accept(nil)
                }

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()) == false
                }
            }

            context("with invalid URL") {
                beforeEach {
                    vm.title.accept("Coding Journal")
                    vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                    vm.url.accept("blog")
                }

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()) == false
                }
            }

            context("with invalid RSS URL") {
                beforeEach {
                    vm.title.accept("Coding Journal")
                    vm.rssUrl.accept("dss")
                    vm.url.accept("https://blog.kulman.sk")
                }

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()) == false
                }
            }

            context("with missing title") {
                beforeEach {
                    vm.title.accept(nil)
                    vm.rssUrl.accept("https://blog.kulman.sk/index.xml")
                    vm.url.accept("https://blog.kulman.sk")
                }

                it("should not validate") {
                    expect(try! vm.isValid.toBlocking().first()) == false
                }
            }
        }
    }
}
