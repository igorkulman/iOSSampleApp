//
//  CustomSourceViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CustomSourceViewControllerDelegate: class {
    func userDidAddCustomSource()
}

class CustomSourceViewController: UIViewController, SetupStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var rssUrlLabel: UILabel!
    @IBOutlet private weak var rssUrlTextField: UITextField!
    @IBOutlet private weak var logoUrlLabel: UILabel!
    @IBOutlet private weak var logoUrlTextField: UITextField!
    @IBOutlet private weak var scrollview: UIScrollView!

    // MARK: - Properties

    var viewModel: CustomSourceViewModel!
    weak var delegate: CustomSourceViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "add_custom_source".localized
        navigationItem.rightBarButtonItem = doneButton

        titleLabel.text = "title".localized
        rssUrlLabel.text = "rss_url".localized
        logoUrlLabel.text = "\("logo_url".localized) (\("optional".localized))"
        urlLabel.text = "url".localized
    }

    private func setupBinding() {
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        titleTextField.rx.text.bind(to: viewModel.title).disposed(by: disposeBag)
        urlTextField.rx.text.bind(to: viewModel.url).disposed(by: disposeBag)
        rssUrlTextField.rx.text.bind(to: viewModel.rssUrl).disposed(by: disposeBag)
        logoUrlTextField.rx.text.bind(to: viewModel.logoUrl).disposed(by: disposeBag)

        viewModel.rssUrl.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: rssUrlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.url.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: urlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.logoUrl.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: logoUrlTextField.rx.textColor).disposed(by: disposeBag)

        NotificationCenter.default.rx.keyboardHeightChanged().subscribe(onNext: { [weak self] height in self?.scrollview.setBottomInset(height: height) }).disposed(by: disposeBag)

        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            if self?.viewModel.submit() == true {
                self?.delegate?.userDidAddCustomSource()
            }
        }).disposed(by: disposeBag)
    }

    private func validityToColor(_ isValid: Bool) -> UIColor {
        return isValid ? UIColor.black : UIColor.red
    }
}
