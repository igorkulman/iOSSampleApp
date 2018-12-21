//
//  DashboardCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import Foundation
import Swinject
import UIKit

enum FeedChildCoordinator {
    case about
}

protocol FeedCoordinatorDelegate: AnyObject {
    func feedCoordinatorDidFinish()
}

final class FeedCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container
    private var childCoordinators = [FeedChildCoordinator: Coordinator]()

    weak var delegate: FeedCoordinatorDelegate?

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    func start() {
        let isTransitionFromSetup = !navigationController.viewControllers.isEmpty
        let vc = container.resolveViewController(FeedViewController.self)
        vc.delegate = self
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
        if isTransitionFromSetup {
            navigationController.viewControllers.remove(at: 0)
        }
    }

    private func showDetail(item: RssItem) {
        let vc = DetailViewController(item: item)
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        navigationController.present(nc, animated: true, completion: nil)
    }

    private func showAbout() {
        let aboutCoordinator = AboutCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.about] = aboutCoordinator
        aboutCoordinator.delegate = self
        aboutCoordinator.start()
    }
}

// MARK: - Delegate

extension FeedCoordinator: AboutCoordinatorDelegate {
    func aboutCoordinatorDidFinish() {
        childCoordinators[.about] = nil
    }
}

extension FeedCoordinator: FeedViewControllerDelegeate {
    func userDidRequestAbout() {
        showAbout()
    }

    func userDidRequestSetup() {
        delegate?.feedCoordinatorDidFinish()
    }

    func userDidRequestItemDetail(item: RssItem) {
        showDetail(item: item)
    }
}

extension FeedCoordinator: DetailViewControllerDelegate {
    func userDidFinish() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
