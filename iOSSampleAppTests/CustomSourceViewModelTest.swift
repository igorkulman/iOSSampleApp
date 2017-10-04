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
@testable import iOSSampleApp

class CustomSourceViewModelTests: XCTestCase {
    func testOkValidation() {
        let vm = CustomSourceViewModel(notificationService: TestNotificationService())
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
        
        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "https://blog.kulman.sk"
        expect(try! vm.isValid.toBlocking().first()!).to(beTrue())
    }
    
    func testInvalidUrlValidation() {
        let vm = CustomSourceViewModel(notificationService: TestNotificationService())
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
        
        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "blog"
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
    }
    
    func testInvalidRssUrlValidation() {
        let vm = CustomSourceViewModel(notificationService: TestNotificationService())
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
        
        vm.title.value = "Coding Journal"
        vm.rssUrl.value = "dss"
        vm.url.value = "https://blog.kulman.sk"
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
    }
    
    func testInvalidTitleValidation() {
        let vm = CustomSourceViewModel(notificationService: TestNotificationService())
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
        
        vm.title.value = nil
        vm.rssUrl.value = "https://blog.kulman.sk/index.xml"
        vm.url.value = "https://blog.kulman.sk"
        expect(try! vm.isValid.toBlocking().first()!).to(beFalse())
    }
}
