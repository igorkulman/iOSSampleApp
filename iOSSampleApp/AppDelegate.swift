//
//  AppDelegate.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container = Container()

    private var appCoordinator: AppCoordinator!

    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        setupLogging()
        setupDependencies()

        return true
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        appCoordinator = AppCoordinator(window: window!, container: container)
        appCoordinator.start()

        window?.makeKeyAndVisible()

        return true
    }
}
