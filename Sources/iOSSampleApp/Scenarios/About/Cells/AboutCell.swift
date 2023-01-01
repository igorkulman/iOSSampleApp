//
//  AboutCell.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import Reusable
import UIKit

final class AboutCell: UITableViewCell, Reusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
