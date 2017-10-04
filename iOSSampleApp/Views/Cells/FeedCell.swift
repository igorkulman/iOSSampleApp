//
//  FeedCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import Reusable

class FeedCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var model: RssItem? {
        didSet {
            if let model = model {
                titleLabel.text = model.title
                descriptionLabel.text = model.description
            }
        }
    }
    
}
