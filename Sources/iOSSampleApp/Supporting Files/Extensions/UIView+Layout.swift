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
    func pin(to view: UIView, guide: UILayoutGuide? = nil, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        let guide = guide ?? view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func fixSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

extension UIScrollView {
    func pin(to view: UIView, with contentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        view.addSubview(self)
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            frameLayoutGuide.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            frameLayoutGuide.topAnchor.constraint(equalTo: guide.topAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentLayoutGuide.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
}
