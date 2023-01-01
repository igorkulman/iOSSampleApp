//
//  UIView+Layout.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func pin(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            topAnchor.constraint(equalTo: guide.topAnchor),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}
