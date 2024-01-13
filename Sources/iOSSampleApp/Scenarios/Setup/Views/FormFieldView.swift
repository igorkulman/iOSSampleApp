//
//  FormFieldView.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 02.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class FormFieldView: UIView {

    // MARK: - UI

    private lazy var label = UILabel() &> {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    fileprivate lazy var textField = UITextField() &> {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    // MARK: - Properties

    var title: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }

    var value: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }

    var isValid = true {
        didSet {
            textField.textColor = isValid ? UIColor.label : UIColor.red
        }
    }

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [label, textField]) &> {
            $0.axis = .vertical
            $0.spacing = 6
        }
        stackView.pin(to: self)
    }
}

// MARK: - Reactive

extension Reactive where Base: FormFieldView {
    var isValid: Binder<Bool> {
        return Binder(base) { view, isValid in
            view.isValid = isValid
        }
    }

    var value: ControlProperty<String?> {
        return base.textField.rx.text
    }
}
