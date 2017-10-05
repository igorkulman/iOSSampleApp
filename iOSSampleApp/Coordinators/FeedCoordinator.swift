//
//  DashboardCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit
import CleanroomLogger
import Swinject

class FeedCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    func start() {
        let isTransitionFromSetup = navigationController.viewControllers.count > 0
        let vc = container.resolveViewController(FeedViewController.self)
        vc.delegate = self
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
        if isTransitionFromSetup {
            navigationController.viewControllers.remove(at: 0)
        }
    }

    private func showDetail(item: RssItem) {
        let vc = container.resolveViewController(DetailViewController.self)
        vc.viewModel.item = item
        navigationController.setBackButton()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Delegate

extension FeedCoordinator: FeedViewControllerDelegeate {
    func userDidRequestItemDetail(item: RssItem) {
        showDetail(item: item)
    }
}
