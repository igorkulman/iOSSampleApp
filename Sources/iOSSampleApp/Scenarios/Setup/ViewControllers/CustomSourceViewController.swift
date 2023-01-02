//
//  CustomSourceViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import RxCocoa
import RxSwift
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

    private lazy var doneButton: UIBarButtonItem = .init() &> {
        $0.title = L10n.done
        $0.style = .plain
    }

    private lazy var rssUrlFormField: FormFieldView = .init() &> {
        $0.title = L10n.rssUrl
    }

    private lazy var urlFormField: FormFieldView = .init() &> {
        $0.title = L10n.url
    }

    private lazy var titleFormField: FormFieldView = .init() &> {
        $0.title = L10n.title
    }

    private lazy var logoUrlFormField: FormFieldView = .init() &> {
        $0.title = "\(L10n.logoUrl) (\(L10n.optional))"
    }

    private lazy var scrollView: UIScrollView = .init()

    // MARK: - Properties

    weak var delegate: CustomSourceViewControllerDelegate?

    // MARK: - Fields

    private let viewModel: CustomSourceViewModel
    private var disposeBag = DisposeBag()

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

        let stackView: UIStackView = .init(arrangedSubviews: [titleFormField, urlFormField, rssUrlFormField, logoUrlFormField]) &> {
            $0.axis = .vertical
            $0.spacing = 12
        }

        let contentView: UIView = .init() &> {
            stackView.pin(to: $0, guide: $0.layoutMarginsGuide, insets: .init(all: 8))
        }

        scrollView.pin(to: view, with: contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    private func setupUI() {
        title = L10n.addCustomSource
        navigationItem.rightBarButtonItem = doneButton
    }

    private func setupBinding() {
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        titleFormField.rx.value.bind(to: viewModel.title).disposed(by: disposeBag)
        urlFormField.rx.value.bind(to: viewModel.url).disposed(by: disposeBag)
        rssUrlFormField.rx.value.bind(to: viewModel.rssUrl).disposed(by: disposeBag)
        logoUrlFormField.rx.value.bind(to: viewModel.logoUrl).disposed(by: disposeBag)

        viewModel.rssUrl.map({ $0?.isValidURL == true }).bind(to: rssUrlFormField.rx.isValid).disposed(by: disposeBag)
        viewModel.url.asObservable().map({ $0?.isValidURL == true }).bind(to: urlFormField.rx.isValid).disposed(by: disposeBag)
        viewModel.logoUrl.asObservable().map({ $0?.isValidURL == true }).bind(to: logoUrlFormField.rx.isValid).disposed(by: disposeBag)

        NotificationCenter.default.rx.keyboardHeightChanged().withUnretained(self).bind { owner, height in owner.scrollView.setBottomInset(height: height) }.disposed(by: disposeBag)

        doneButton.rx.tap.withLatestFrom(viewModel.source.flatMap(ignoreNil)).withUnretained(self).bind { owner, source in owner.delegate?.userDidAddCustomSource(source: source) }.disposed(by: disposeBag)
    }
}
