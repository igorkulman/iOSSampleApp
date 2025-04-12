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

    private lazy var doneButton = UIBarButtonItem() &> {
        $0.title = NSLocalizedString("done", comment: "")
        $0.style = .plain
    }

    private lazy var rssUrlFormField = FormFieldView() &> {
        $0.title = NSLocalizedString("rss_url", comment: "")
    }

    private lazy var urlFormField = FormFieldView() &> {
        $0.title = NSLocalizedString("url", comment: "")
    }

    private lazy var titleFormField = FormFieldView() &> {
        $0.title = NSLocalizedString("title", comment: "")
    }

    private lazy var logoUrlFormField = FormFieldView() &> {
        $0.title = "\(NSLocalizedString("logo_url", comment: "")) (\(NSLocalizedString("optional", comment: "")))"
    }

    private lazy var scrollView = UIScrollView() &> {
        $0.backgroundColor = .systemBackground
    }

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

        let stackView = UIStackView(arrangedSubviews: [titleFormField, urlFormField, rssUrlFormField, logoUrlFormField]) &> {
            $0.axis = .vertical
            $0.spacing = 12
        }

        let contentView = UIView() &> {
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
        title = NSLocalizedString("add_custom_source", comment: "")
        navigationItem.rightBarButtonItem = doneButton
    }

    private func setupBinding() {
        viewModel.isValid.drive(doneButton.rx.isEnabled).disposed(by: disposeBag)
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct CustomSourceViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: CustomSourceViewController(viewModel: CustomSourceViewModel())).asPreview()
    }
}
#endif
