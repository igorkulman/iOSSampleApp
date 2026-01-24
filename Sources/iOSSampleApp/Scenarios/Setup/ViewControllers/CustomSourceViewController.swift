//
//  CustomSourceViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit

protocol CustomSourceViewControllerDelegate: AnyObject {
    /**
     Invokes when user adds a new custom RSS source

     - Parameter source: newly added RSS source
     */
    func userDidAddCustomSource(source: RssSource)
}

final class CustomSourceViewController: UIViewController {

    // MARK: - UI

    private lazy var doneButton = UIBarButtonItem(
        title: String(localized: .done),
        primaryAction: UIAction { [weak self] _ in
            guard let self = self, let source = self.viewModel.source else { return }
            self.delegate?.userDidAddCustomSource(source: source)
        }
    )

    private lazy var rssUrlFormField = FormFieldView() &> {
        $0.title = String(localized: .rssUrl)
        $0.textField.addAction(UIAction { [weak self] action in
            self?.viewModel.rssUrl = (action.sender as? UITextField)?.text
        }, for: .editingChanged)
    }

    private lazy var urlFormField = FormFieldView() &> {
        $0.title = String(localized: .url)
        $0.textField.addAction(UIAction { [weak self] action in
            self?.viewModel.url = (action.sender as? UITextField)?.text
        }, for: .editingChanged)
    }

    private lazy var titleFormField = FormFieldView() &> {
        $0.title = String(localized: .title)
        $0.textField.addAction(UIAction { [weak self] action in
            self?.viewModel.title = (action.sender as? UITextField)?.text
        }, for: .editingChanged)
    }

    private lazy var logoUrlFormField = FormFieldView() &> {
        $0.title = "\(String(localized: .logoUrl)) (\(String(localized: .optional)))"
        $0.textField.addAction(UIAction { [weak self] action in
            self?.viewModel.logoUrl = (action.sender as? UITextField)?.text
        }, for: .editingChanged)
    }

    private lazy var scrollView = UIScrollView() &> {
        $0.backgroundColor = .systemBackground
    }

    // MARK: - Properties

    weak var delegate: CustomSourceViewControllerDelegate?

    // MARK: - Fields

    private let viewModel: CustomSourceViewModel
    private var keyboardObserver: NSObjectProtocol?

    init(viewModel: CustomSourceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func loadView() {
        let view = UIView()
        defer { self.view = view }

        let stackView = UIStackView(arrangedSubviews: [titleFormField, urlFormField, rssUrlFormField, logoUrlFormField]) &> {
            $0.axis = .vertical
            $0.spacing = 12
        }

        let contentView = UIView() &> {
            stackView.pin(to: $0, guide: $0.layoutMarginsGuide, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        scrollView.pin(to: view, with: contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        observeKeyboard()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // UIKit automatically tracks @Observable properties accessed here
        doneButton.isEnabled = viewModel.isValid

        rssUrlFormField.isValid = viewModel.rssUrl?.isValidURL ?? false || viewModel.rssUrl?.isEmpty ?? true
        urlFormField.isValid = viewModel.url?.isValidURL ?? false || viewModel.url?.isEmpty ?? true
        logoUrlFormField.isValid = viewModel.logoUrl?.isValidURL ?? false || viewModel.logoUrl?.isEmpty ?? true
    }

    private func setupUI() {
        title = String(localized: .addCustomSource)
        navigationItem.rightBarButtonItem = doneButton
    }

    private func observeKeyboard() {
        keyboardObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }

            let keyboardHeight = keyboardFrame.origin.y >= UIScreen.main.bounds.height ? 0 : keyboardFrame.height
            self.scrollView.setBottomInset(height: keyboardHeight)
        }
    }

    deinit {
        if let observer = keyboardObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: CustomSourceViewController(viewModel: CustomSourceViewModel()))
}
