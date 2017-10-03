//
//  RssSourceCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class RssSourceCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: RssSourceViewModel? {
        didSet {
            if let vm = viewModel {
                titleLabel.text = vm.source.title
                urlLabel.text = vm.source.url
                vm.isSelected.asObservable().subscribe(onNext: {[weak self] selected in
                    self?.accessoryType = selected ? .checkmark : .none
                }).disposed(by: disposeBag)
            }
        }
    }
    
    // MARK: - Fields
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
