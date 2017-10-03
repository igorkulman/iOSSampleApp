//
//  CustomSourceViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

class CustomSourceViewController: UIViewController, SetupStoryboardLodable {

    // MARK: - Properties
    
    var viewModel: CustomSourceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "add_custom_source".localized
    }
}
