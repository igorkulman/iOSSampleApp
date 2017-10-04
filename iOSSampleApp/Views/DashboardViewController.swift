//
//  DashboardViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, DashboardStoryboardLodable {

    // MARK: - Properties
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "feed".localized
    }
}
