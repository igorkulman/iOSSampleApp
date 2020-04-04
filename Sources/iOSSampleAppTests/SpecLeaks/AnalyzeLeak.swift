//
//  AnalyzeLeak.swift
//  UnitTestLeaks
//
//  Created by Leandro Perez on 03/02/2018.
//  Copyright © 2018 Leandro Perez. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    public typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    public typealias OSViewController = NSViewController
#endif

import Quick
import Nimble

func view(_ vc: AnyObject?) {
    if let vc = vc as? OSViewController {
        _ = vc.view //To call viewDidLoad on the vc
    }
}

public func getOSViewController() -> OSViewController {
    return OSViewController()
}

struct AnalyzeLeak {
    func execute( constructor: LeakTestConstructor, shouldLeak: Bool = false ) {

        var mayBeLeaking: AnyObject?
        let leaksAnalyzer = LeaksAnalyzer()

        autoreleasepool {
            leaksAnalyzer.leakedObject = nil

            mayBeLeaking = constructor()

            view(mayBeLeaking)

            leaksAnalyzer.analize(mayBeLeaking!)
            mayBeLeaking = nil
        }

        if shouldLeak {
            expect(leaksAnalyzer.leakedObject).toEventuallyNot(beNil())
        } else {
            expect(leaksAnalyzer.leakedObject).toEventually(beNil())
        }
    }
}
