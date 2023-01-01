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

    private lazy var rssUrlLabel: UILabel = .init() &> {
        $0.text = L10n.rssUrl
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var rssUrlTextField: UITextField = .init() &> {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var urlLabel: UILabel = .init() &> {
        $0.text = L10n.url
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var urlTextField: UITextField = .init() &> {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var titleLabel: UILabel = .init() &> {
        $0.text = L10n.title
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var titleTextField: UITextField = .init() &> {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var logoUrlLabel: UILabel = .init() &> {
        $0.text = "\(L10n.logoUrl) (\(L10n.optional))"
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private lazy var logoUrlTextField: UITextField = .init() &> {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.preferredFont(forTextStyle: .body)
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

        let views = [(titleLabel, titleTextField), (urlLabel, urlTextField), (rssUrlLabel, rssUrlTextField), (logoUrlLabel, logoUrlTextField)].map {
            let stackView: UIStackView = .init(arrangedSubviews: [$0.0, $0.1]) &> {
                $0.axis = .vertical
                $0.spacing = 6
            }
            return stackView
        }

        let stackView: UIStackView = .init(arrangedSubviews: views) &> {
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
        titleTextField.rx.text.bind(to: viewModel.title).disposed(by: disposeBag)
        urlTextField.rx.text.bind(to: viewModel.url).disposed(by: disposeBag)
        rssUrlTextField.rx.text.bind(to: viewModel.rssUrl).disposed(by: disposeBag)
        logoUrlTextField.rx.text.bind(to: viewModel.logoUrl).disposed(by: disposeBag)

        viewModel.rssUrl.asObservable().map({ $0?.isValidURL == true ? UIColor.black : UIColor.red }).bind(to: rssUrlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.url.asObservable().map({ $0?.isValidURL == true ? UIColor.black : UIColor.red }).bind(to: urlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.logoUrl.asObservable().map({ $0?.isValidURL == true ? UIColor.black : UIColor.red }).bind(to: logoUrlTextField.rx.textColor).disposed(by: disposeBag)

        NotificationCenter.default.rx.keyboardHeightChanged().withUnretained(self).bind { owner, height in owner.scrollView.setBottomInset(height: height) }.disposed(by: disposeBag)

        doneButton.rx.tap.withLatestFrom(viewModel.source.flatMap(ignoreNil)).withUnretained(self).bind { owner, source in owner.delegate?.userDidAddCustomSource(source: source) }.disposed(by: disposeBag)
    }
}
