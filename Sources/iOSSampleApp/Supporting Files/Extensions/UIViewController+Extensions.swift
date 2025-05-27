//
//  UIViewController+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 16/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

protocol ToastCapable: AnyObject {
    func showErrorToast(message: String)
}

extension ToastCapable {
    func showErrorToast(message: String) {
        ToastBanner.show(message: message)
    }
}

final class ToastBanner {
    static func show(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let banner = UIView() &> {
            $0.backgroundColor = .systemRed
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let label = UILabel() &> {
            $0.text = message
            $0.textColor = .white
            $0.font = UIFont.preferredFont(forTextStyle: .body)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        banner.addSubview(label)
        window.addSubview(banner)

        let topConstraint = banner.topAnchor.constraint(equalTo: window.topAnchor)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            topConstraint,

            label.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: banner.safeAreaLayoutGuide.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -6)
        ])

        window.layoutIfNeeded()
        let height = banner.frame.height
        banner.transform = CGAffineTransform(translationX: 0, y: -height)

        UIView.animate(
            withDuration: 0.3,
            animations: {
                banner.transform = .identity
            },
            completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    UIView.animate(
                        withDuration: 0.3,
                        animations: {
                            banner.transform = CGAffineTransform(translationX: 0, y: -height)
                        },
                        completion: { _ in
                            banner.removeFromSuperview()
                        }
                    )
                }
            }
        )
    }
}
