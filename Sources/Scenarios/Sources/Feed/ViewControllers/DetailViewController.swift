//
//  DetailViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 05/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Operators
import Resources
import RxSwift
import UIKit
import WebKit

protocol DetailViewControllerDelegate: AnyObject {
    /**
     Invoked when user finished looking at the RSS source detail
     */
    func detailViewControllerDidFinish()
}

final class DetailViewController: UIViewController {

    // MARK: - UI

    private lazy var backBarButtonItem: UIBarButtonItem = .init() &> {
        $0.image = Asset.back.image
        $0.style = .plain
    }

    private lazy var forwardBarButtonItem: UIBarButtonItem = .init() &> {
        $0.image = Asset.forward.image
        $0.style = .plain
    }

    private lazy var reloadBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .refresh, target: self, action: nil)

    private lazy var stopBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .stop, target: self, action: nil)

    private lazy var doneBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .stop, target: self, action: nil)

    private lazy var flexibleSpaceBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    private lazy var progressView: UIProgressView = .init(progressViewStyle: .default) &> {
        $0.trackTintColor = .clear
    }

    // MARK: - Properties

    weak var delegate: DetailViewControllerDelegate?

    // MARK: - Fields

    private let item: RssItem
    private var webView: WKWebView?
    private var disposeBag = DisposeBag()

    // MARK: - Setup

    init(item: RssItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        notImplemented()
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true

        view = webView
        self.webView = webView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let navigationController = navigationController else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationController.navigationBar.frame.size.height - progressView.frame.size.height, width: navigationController.navigationBar.frame.size.width, height: progressView.frame.size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = doneBarButtonItem
        title = item.title

        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.navigationBar.addSubview(progressView)
    }

    private func setupData() {
        if let link = item.link, let url = URL(string: link) {
            load(url)
        }
    }

    private func setupBinding() {
        backBarButtonItem.rx.tap.withUnretained(self).bind { owner, _ in
            owner.webView?.goBack()
        }.disposed(by: disposeBag)

        forwardBarButtonItem.rx.tap.withUnretained(self).bind { owner, _ in
            owner.webView?.goForward()
        }.disposed(by: disposeBag)

        doneBarButtonItem.rx.tap.withUnretained(self).bind { owner, _ in
            owner.delegate?.detailViewControllerDidFinish()
        }.disposed(by: disposeBag)

        reloadBarButtonItem.rx.tap.withUnretained(self).bind { owner, _ in
            owner.webView?.stopLoading()
            if owner.webView?.url != nil {
                owner.webView?.reload()
            } else {
                if let link = owner.item.link, let url = URL(string: link) {
                    owner.load(url)
                }
            }
        }.disposed(by: disposeBag)

        guard let webView = webView else {
            return
        }

        webView.rx.canGoBack.bind(to: backBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        webView.rx.canGoForward.bind(to: forwardBarButtonItem.rx.isEnabled).disposed(by: disposeBag)

        webView.rx.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        webView.rx.estimatedProgress.withUnretained(self).bind { owner, estimatedProgress in
            owner.progressView.alpha = 1
            owner.progressView.setProgress(Float(estimatedProgress), animated: true)

            guard estimatedProgress >= 1.0 else {
                return
            }

            owner.animateProgressAlpha()
        }.disposed(by: disposeBag)

        webView.rx.loading.map { [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, reloadBarButtonItem, stopBarButtonItem] (isLoading: Bool) -> [UIBarButtonItem] in
            if isLoading {
                return [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, flexibleSpaceBarButtonItem, stopBarButtonItem]
            } else {
                return [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, flexibleSpaceBarButtonItem, reloadBarButtonItem]
            }
        }.bind(to: self.rx.toolbarItems).disposed(by: disposeBag)
    }

    // MARK: - Internal

    private func animateProgressAlpha() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
            self?.progressView.alpha = 0
            }, completion: { [weak self] _ in
                self?.progressView.setProgress(0, animated: false)
        })
    }

    private func load(_ url: URL) {
        guard let webView = webView else {
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }
}
