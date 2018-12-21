//
//  DetailViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 05/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import RxCocoa
import RxSwift
import UIKit
import WebKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewControllerDidFinish()
}

final class DetailViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Properties

    weak var delegate: DetailViewControllerDelegate?

    // MARK: - Fields

    private let item: RssItem

    private var webView: WKWebView?

    private let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: self, action: nil)
    private let forwardBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Forward"), style: .plain, target: self, action: nil)
    private let reloadBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
    private let stopBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
    private let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
    private let flexibleSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .clear
        return progressView
    }()

    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(item: RssItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    // MARK: - Setup

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
        backBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in
            self?.webView?.goBack()
        }).disposed(by: disposeBag)

        forwardBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in
            self?.webView?.goForward()
        }).disposed(by: disposeBag)

        doneBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.detailViewControllerDidFinish()
        }).disposed(by: disposeBag)

        reloadBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }

            self.webView?.stopLoading()
            if self.webView?.url != nil {
                self.webView?.reload()
            } else {
                if let link = self.item.link, let url = URL(string: link) {
                    self.load(url)
                }
            }
        }).disposed(by: disposeBag)

        guard let webView = webView else {
            return
        }

        webView.rx.canGoBack.bind(to: backBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        webView.rx.canGoForward.bind(to: forwardBarButtonItem.rx.isEnabled).disposed(by: disposeBag)

        webView.rx.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        webView.rx.estimatedProgress.subscribe(onNext: { [weak self] estimatedProgress in
            self?.progressView.alpha = 1
            self?.progressView.setProgress(Float(estimatedProgress), animated: true)

            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    self?.progressView.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.progressView.setProgress(0, animated: false)
                })
            }
        }).disposed(by: disposeBag)

        webView.rx.loading.map { [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, reloadBarButtonItem, stopBarButtonItem] (isLoading: Bool) -> [UIBarButtonItem] in
            if isLoading {
                return [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, flexibleSpaceBarButtonItem, stopBarButtonItem]
            } else {
                return [backBarButtonItem, flexibleSpaceBarButtonItem, forwardBarButtonItem, flexibleSpaceBarButtonItem, reloadBarButtonItem]
            }
        }.bind(to: self.rx.toolbarItems).disposed(by: disposeBag)
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
