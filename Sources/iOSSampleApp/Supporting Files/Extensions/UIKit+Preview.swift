//
//  UIKit+Preview.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 07.02.2024.
//  Copyright © 2024 Igor Kulman. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - UIViewController extensions

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        var viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            // No-op
        }
    }

    func asPreview() -> some View {
        Preview(viewController: self)
    }
}

// MARK: - UIView Extensions

extension UIView {
    private struct Preview: UIViewRepresentable {
        var view: UIView

        func makeUIView(context: Context) -> UIView {
            view
        }

        func updateUIView(_ view: UIView, context: Context) {
            // No-op
        }
    }

    @available(iOS 13, *)
    func asPreview() -> some View {
        Preview(view: self)
    }
}
