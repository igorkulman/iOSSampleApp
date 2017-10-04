//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Properties
    
    var viewModel: FeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "feed".localized
    }
}
