//
//  CustomSourceViewModelTest.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import RxBlocking
import RxTest
import RxSwift
@testable import iOSSampleApp

class CustomSourceViewModelTests: XCTestCase {
    private let bag = DisposeBag()

    func testOkValidation() {
        let vm = CustomSourceViewModel()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        vm.isValid.subscribe(observer).disposed(by: bag)
        scheduler.start()

        expect(observer.events.last!.value.element!).to(beFalse())

        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "https://blog.kulman.sk"
        expect(observer.events.last!.value.element!).to(beTrue())
    }

    func testInvalidUrlValidation() {
        let vm = CustomSourceViewModel()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        vm.isValid.subscribe(observer).disposed(by: bag)
        scheduler.start()

        expect(observer.events.last!.value.element!).to(beFalse())

        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "blog"
        expect(observer.events.last!.value.element!).to(beFalse())
    }

    func testInvalidRssUrlValidation() {
        let vm = CustomSourceViewModel()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        vm.isValid.subscribe(observer).disposed(by: bag)
        scheduler.start()

        expect(observer.events.last!.value.element!).to(beFalse())

        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "dss"
        vm.url.value = "https://blog.kulman.sk"
        expect(observer.events.last!.value.element!).to(beFalse())
    }

    func testInvalidTitleValidation() {
        let vm = CustomSourceViewModel()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        vm.isValid.subscribe(observer).disposed(by: bag)
        scheduler.start()

        expect(observer.events.last!.value.element!).to(beFalse())

        vm.title.value = nil
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "https://blog.kulman.sk"
        expect(observer.events.last!.value.element!).to(beFalse())
    }
}
